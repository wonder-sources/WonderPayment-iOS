import QMUIKit

class BankCardView : TGLinearLayout {
    
    lazy var backButton: UIButton = createBackButton()
    lazy var codeView = DialingCodeView()
    lazy var confirmButton = QMUIButton()
    lazy var formView = createFormView()
    lazy var formLayout = TGLinearLayout(.vert)
    
    var form = CardForm()
    
    convenience init() {
        self.init(frame: .zero, orientation: .vert)
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
        confirmButton.backgroundColor = WonderPayment.uiConfig.secondaryButtonBackground
        confirmButton.qmui_setImageTintColor(WonderPayment.uiConfig.secondaryButtonDisableBackground, for: .disabled)
        confirmButton.setTitle("confirm".i18n, for: .normal)
        confirmButton.setTitleColor(WonderPayment.uiConfig.secondaryButtonColor, for: .normal)
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
        
        let cardNumberView = createInputView(title: "cardNumber".i18n, placeholder: "inputCardNumber".i18n, keyboardType: .numberPad, maxLength: 19, format: "XXXX XXXX ", tag: 1)
        cardNumberView.tg_top.equal(10)
        formView.addSubview(cardNumberView)
        
        let hLayout = TGLinearLayout(.horz)
        hLayout.tg_width.equal(.fill)
        hLayout.tg_height.equal(.wrap)
        hLayout.tg_top.equal(16)
        formView.addSubview(hLayout)
        
        let expiryView = createInputView(title: "expiryDate".i18n, placeholder: "YY/MM", keyboardType: .numberPad, maxLength: 4,format: "XX/XX", tag: 2)
        expiryView.tg_right.equal(16)
        hLayout.addSubview(expiryView)
        
        let cvvView = createInputView(title: "cvv".i18n, placeholder: "CVV", keyboardType: .numberPad, maxLength: 3, tag: 3)
        hLayout.addSubview(cvvView)
        
        let firstNameView = createInputView(title: "firstName".i18n, placeholder: "inputFirstName".i18n, maxLength: 30, tag: 4)
        firstNameView.tg_top.equal(16)
        formView.addSubview(firstNameView)
        
        let lastNameView = createInputView(title: "lastName".i18n, placeholder: "inputLastName".i18n, maxLength: 30, tag: 5)
        lastNameView.tg_top.equal(16)
        formView.addSubview(lastNameView)
        
       
        let phoneNumberView = createInputView(title: "phoneNumber".i18n, placeholder: "inputPhoneNumber".i18n, keyboardType: .numberPad, maxLength: 12, leftView: codeView, tag: 6)
        phoneNumberView.tg_top.equal(16)
        formView.addSubview(phoneNumberView)
        
        let hLayout2 = TGLinearLayout(.horz)
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
        
        let saveLabel = createLabel(text: "saveCardInfo".i18n)
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
        label.textColor = WonderPayment.uiConfig.primaryButtonColor
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
        button.setTitle("back".i18n, for: .normal)
        button.setTitleColor(WonderPayment.uiConfig.primaryTextColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Futura-Medium", size: 16)
        button.tg_width.equal(.wrap)
        button.tg_height.equal(.wrap)
        return button
    }
    
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font =  UIFont(name: "Futura-Medium", size: 16)
        label.text = text
        label.textColor = WonderPayment.uiConfig.secondaryTextColor
        label.tg_width.equal(.wrap)
        label.tg_height.equal(.wrap)
        return label
    }
    
    private func createInputView(title: String, placeholder: String, keyboardType: UIKeyboardType = .default, maxLength: UInt, leftView: UIView? = nil, format: String? = nil, tag: Int = 0) -> UIView {
        
        let layout = TGLinearLayout(.vert)
        layout.tg_width.equal(.fill)
        layout.tg_height.equal(.wrap)
        
        let label = createLabel(text: title)
        layout.addSubview(label)
        
        let textField = TextFieldView(
            placeholder: placeholder,
            keyboardType: keyboardType,
            maxLength: maxLength,
            leftView: leftView,
            format: format
        )
        textField.tag = tag
        textField.addTarget(self, action: #selector(onTextFieldValueChange(_:)), for: .editingChanged)
        textField.tg_top.equal(4)
        layout.addSubview(textField)
        
        return layout
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
        confirmButton.isEnabled = form.isValid
    }
    
    func reset() {
        formLayout.tg_removeAllSubviews()
        form = CardForm()
        formView = createFormView()
        formLayout.addSubview(formView)
        confirmButton.isEnabled = false
    }
}
