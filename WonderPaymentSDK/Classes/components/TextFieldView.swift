import QMUIKit

class TextFieldView : QMUITextField {
    
    var maxLength: UInt = UInt.max
    var format: String?
    
    convenience init(placeholder: String = "", keyboardType: UIKeyboardType = .default, maxLength: UInt = UInt.max, leftView: UIView? = nil, format: String? = nil) {
        self.init(frame: .zero)
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.maxLength = maxLength
        self.leftView = leftView
        self.leftViewMode = .always
        self.format = format
        self.initView()
    }
    
    private func initView() {
        textInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tg_width.equal(.fill)
        tg_height.equal(50)
        backgroundColor = WonderPayment.uiConfig.textFieldBackground
        textColor = WonderPayment.uiConfig.primaryTextColor
        tintColor = WonderPayment.uiConfig.primaryTextColor
        layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                NSAttributedString.Key.foregroundColor: WonderPayment.uiConfig.secondaryTextColor,
                NSAttributedString.Key.font : UIFont(name: "Futura", size: 16)!
            ]
        )
        returnKeyType = .done
        self.delegate = self
    }
}

extension TextFieldView : QMUITextFieldDelegate {
    
    private func formatStr(_ str: String, format: String) -> String {
        var formatted = ""
        let strArr = Array(str)
        let formatArr = Array(format)
        var i = 0
        while (i < str.count) {
            for fchr in formatArr {
                if i >= str.count {
                    break
                }
                if fchr == "X" {
                    formatted.append(strArr[i])
                    i+=1
                } else {
                    formatted.append(fchr)
                }
            }
            
        }
        return formatted
    }
    
    private func getValidCharacters(_ str: String, format: String) -> String {
        //有效字符
        var validCharacters = ""
        //无效字符
        var invalidCharacters = ""
        for chr in format {
            if chr != "X" {
                invalidCharacters.append(chr)
            }
        }
        for chr in str {
            if invalidCharacters.index(of: chr) == nil {
                validCharacters.append(chr)
            }
        }
        return validCharacters
    }
    
    
    
    func textField(_ textField: UITextField!, shouldChangeCharactersIn range: NSRange, replacementString string: String!, originalValue: Bool) -> Bool {
  
        if format == nil && (textField.text?.count ?? 0) + string.count <= maxLength {
            return true
        }
            
        let oldText = textField.text ?? ""
        var newText = ""
        if range.lowerBound == oldText.count {
            newText = "\(oldText)\(string ?? "")"
        } else {
            newText = oldText.replacingCharacters(in: Range(range, in: oldText)!,with: string)
        }
        
        if format != nil {
            let validCharacters = getValidCharacters(newText, format: format!)
            if validCharacters.count > maxLength {
                return false
            }
            newText = formatStr(validCharacters, format: format!)
        } else {
            if newText.count > maxLength {
                return false
            }
        }
        
        textField.text = newText
        let startPosition = textField.beginningOfDocument
        let offset = string.isEmpty ? range.lowerBound : range.lowerBound + newText.count
        let cursorPosition = textField.position(from: startPosition, offset: offset) ?? textField.endOfDocument
        textField.selectedTextRange = textField.textRange(from: cursorPosition, to: cursorPosition)
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(false)
        return false
    }
}
