import QMUIKit
import TangramKit

class BankCardView : TGLinearLayout {
    
    lazy var backButton: UIButton = createBackButton()
    lazy var codeView = DialingCodeView()
    lazy var confirmButton = QMUIButton()
    lazy var formView = createFormView()
    lazy var formLayout = TGLinearLayout(.vert)
    lazy var cardNumberField = createFormTextField(title: "cardNumber".i18n, placeholder: "inputCardNumber".i18n, keyboardType: .numberPad, maxLength: 19, format: "XXXX XXXX ", tag: 1)
    lazy var expiryField = createFormTextField(title: "expiryDate".i18n, placeholder: "YY/MM", keyboardType: .numberPad, maxLength: 4,format: "XX/XX", tag: 2)
    lazy var cvvField = createFormTextField(title: "cvv".i18n, placeholder: "CVV", keyboardType: .numberPad, maxLength: 3, tag: 3)
    lazy var firstNameField = createFormTextField(title: "firstName".i18n, placeholder: "inputFirstName".i18n, maxLength: 30, tag: 4)
    lazy var lastNameField = createFormTextField(title: "lastName".i18n, placeholder: "inputLastName".i18n, maxLength: 30, tag: 5)
    lazy var phoneNumberField = createFormTextField(title: "phoneNumber".i18n, placeholder: "inputPhoneNumber".i18n, keyboardType: .numberPad, maxLength: 12, leftView: codeView, tag: 6)
    
    var form = CardForm()
    
    var addMode = false
    
    convenience init(addMode: Bool = false) {
        self.init(frame: .zero, orientation: .vert)
        self.addMode = addMode
        self.initView()
    }
    
    
    private func initView() {
        self.tg_width.equal(.fill)
        self.tg_height.equal(.wrap)
        
        let header = headerView()
        addSubview(header)
        
        formLayout.tg_width.equal(.fill)
        formLayout.tg_height.equal(.wrap)
        addSubview(formLayout)
        
        formLayout.addSubview(formView)
        
        confirmButton.isEnabled = false
        confirmButton.backgroundColor = WonderPayment.uiConfig.primaryButtonBackground
        confirmButton.qmui_setImageTintColor(WonderPayment.uiConfig.primaryButtonDisableBackground, for: .disabled)
        confirmButton.setTitle("saveThisCard".i18n, for: .normal)
        confirmButton.setTitleColor(WonderPayment.uiConfig.primaryButtonColor, for: .normal)
        confirmButton.layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        confirmButton.titleLabel?.font = UIFont(name: "Futura-Medium", size: 16)
        confirmButton.tg_height.equal(52)
        confirmButton.tg_width.equal(.fill)
        confirmButton.tg_top.equal(16)
        addSubview(confirmButton)
    }
    
    private func createFormView() -> TGLinearLayout {
        let formView = TGLinearLayout(.vert)
        formView.tg_width.equal(.fill)
        formView.tg_height.equal(.wrap)
        
        
        cardNumberField.tg_top.equal(10)
        cardNumberField.validator = validateCardNumber
        formView.addSubview(cardNumberField)
        
        let hLayout = TGLinearLayout(.horz)
        hLayout.tg_width.equal(.fill)
        hLayout.tg_height.equal(.wrap)
        hLayout.tg_top.equal(16)
        formView.addSubview(hLayout)
        
        expiryField.tg_right.equal(16)
        expiryField.validator = validateExpiry
        hLayout.addSubview(expiryField)
        
        cvvField.validator = validateCVV
        hLayout.addSubview(cvvField)
        
        firstNameField.tg_top.equal(16)
        firstNameField.validator = validateName
        formView.addSubview(firstNameField)
        
        lastNameField.tg_top.equal(16)
        lastNameField.validator = validateName
        formView.addSubview(lastNameField)
        
        phoneNumberField.tg_top.equal(16)
        phoneNumberField.validator = validatePhone
        formView.addSubview(phoneNumberField)
        
        let hLayout2 = TGLinearLayout(.horz)
        hLayout2.isHidden = addMode
        hLayout2.tg_width.equal(.fill)
        hLayout2.tg_height.equal(.wrap)
        hLayout2.tg_top.equal(16)
        formView.addSubview(hLayout2)
        
        let checkBox = CheckBox()
        checkBox.onChange = {
            [weak self] selected in
            self?.form.save = selected
        }
        checkBox.isSelected = true
        checkBox.tg_width.equal(.wrap)
        checkBox.tg_height.equal(.wrap)
        hLayout2.addSubview(checkBox)
        
        let saveLabel = Label("saveCardInfo".i18n, style: .secondary)
        saveLabel.tg_width.equal(.fill)
        saveLabel.tg_height.equal(.wrap)
        saveLabel.tg_left.equal(4)
        hLayout2.addSubview(saveLabel)
        return formView
    }
    
    private func headerView() -> TGLinearLayout {
        let header = TGLinearLayout(.vert)
        header.tg_width.equal(.fill)
        header.tg_height.equal(.wrap)
        
        let topLayout = TGLinearLayout(.horz)
        topLayout.tg_width.equal(.fill)
        topLayout.tg_height.equal(.wrap)
        header.addSubview(topLayout)
        
        backButton.tg_right.equal(100%)
        topLayout.addSubview(backButton)
        
        let label = UILabel()
        label.text = "cardPayment".i18n
        label.font = UIFont(name: "Futura-Medium", size: 16)
        label.textColor = WonderPayment.uiConfig.secondaryButtonColor
        label.tg_width.equal(.wrap)
        label.tg_height.equal(.wrap)
        topLayout.addSubview(label)
        
        let banksView = BanksView(spacing: 6)
        banksView.tg_top.equal(8)
        banksView.tg_right.equal(0)
        header.addSubview(banksView)
        
        return header
    }
    
    private func createBackButton() -> UIButton {
        let button = QMUIButton()
        button.setTitle("← \("back".i18n)", for: .normal)
        button.setTitleColor(WonderPayment.uiConfig.primaryTextColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Futura-Medium", size: 16)
        button.tg_width.equal(.wrap)
        button.tg_height.equal(.wrap)
        return button
    }
    
    private func createFormTextField(title: String, placeholder: String, keyboardType: UIKeyboardType = .default, maxLength: UInt, leftView: UIView? = nil, format: String? = nil, tag: Int = 0) -> FormTextFieldView {
        let formTextField = FormTextFieldView(title: title, placeholder: placeholder, keyboardType: keyboardType, maxLength: maxLength, leftView: leftView, format: format)
        formTextField.textField.tag = tag
        formTextField.textField.addTarget(self, action: #selector(onTextFieldValueChange(_:)), for: .editingChanged)
        return formTextField
    }
    
    @objc private func onTextFieldValueChange(_ sender: UITextField) {
        switch(sender.tag) {
        case 1:
            form.number = (sender.text ?? "").replace(" ", with: "")
        case 2:
            form.expDate = sender.text ?? ""
        case 3:
            form.cvv = sender.text ?? ""
        case 4:
            form.firstName = sender.text ?? "".trim()
        case 5:
            form.lastName = sender.text ?? "".trim()
        case 6:
            if (sender.text?.count ?? 0) > 0 {
                form.phone = "+\(codeView.dialingCode) \(sender.text!)"
            } else {
                form.phone = ""
            }
        default: ()
        }
        let formValid = cardNumberField.isValid 
        && expiryField.isValid
        && cvvField.isValid
        && firstNameField.isValid
        && lastNameField.isValid
        && phoneNumberField.isValid
        confirmButton.isEnabled = formValid
    }
    
    func reset() {
        formLayout.tg_removeAllSubviews()
        form = CardForm()
        formView = createFormView()
        formLayout.addSubview(formView)
        confirmButton.isEnabled = false
    }
}


extension BankCardView {
    private func validateCardNumber(text: String?) -> String? {
        let cardNumber = text?.trim().replace(" ", with: "") ?? ""
        if cardNumber.isEmpty {
            return "required".i18n
        }
        if cardNumber.count < 14 {
            return "enterValidNumber".i18n
        }
        return nil
    }
    
    private func validateExpiry(text: String?) -> String? {
        let expiry = text?.trim() ?? ""
        if expiry.isEmpty {
            return "required".i18n
        }
        if expiry.count < 5 {
            return "enterValidExpiry".i18n
        }
        let arr = expiry.split(separator: "/")
        //let expYear = String(arr.first!)
        let expMonth = String(arr.last!)
        let month = Int(expMonth) ?? 0
        if (month < 1 || month > 12) {
            return "enterValidExpiry".i18n
        }
        return nil
    }
    
    private func validateCVV(text: String?) -> String? {
        let cvv = text?.trim() ?? ""
        if cvv.isEmpty {
            return "required".i18n
        }
        if cvv.count < 3 {
            return "enterValidCVV".i18n
        }
        return nil
    }
    
    private func validateName(text: String?) -> String? {
        let name = text?.trim() ?? ""
        if name.isEmpty {
            return "required".i18n
        }
        
        let pattern = "^[a-zA-Z\\u4E00-\\u9FA5]*$" // 匹配英文字母和中文汉字
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: name.utf16.count)
        if regex.firstMatch(in: name, options: [], range: range) == nil {
            return "nameShouldNot".i18n
        }
        return nil
    }
    
    private func validatePhone(text: String?) -> String? {
        let phone = text?.trim() ?? ""
        if phone.isEmpty {
            return "required".i18n
        }
        
        let pattern = "^[0-9]{5,}$"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: phone.utf16.count)
        if regex.firstMatch(in: phone, options: [], range: range) == nil {
            return "invalidPhone".i18n
        }
        return nil
    }
}
