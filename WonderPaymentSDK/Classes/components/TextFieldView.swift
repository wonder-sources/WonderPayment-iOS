
protocol TextFieldViewDelegate: UITextFieldDelegate {}

class TextFieldView : UITextField {
    
    var maxLength: UInt = UInt.max
    var format: String?
    var textInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    weak var textFieldViewDelegate: TextFieldViewDelegate?
    
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
        tg_width.equal(.fill)
        tg_height.equal(50)
        backgroundColor = WonderPayment.uiConfig.textFieldBackground
        textColor = WonderPayment.uiConfig.primaryTextColor
        tintColor = WonderPayment.uiConfig.primaryTextColor
        layer.cornerRadius = min(WonderPayment.uiConfig.borderRadius, 25)
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                NSAttributedString.Key.foregroundColor: WonderPayment.uiConfig.secondaryTextColor,
                NSAttributedString.Key.font : UIFont(name: "Outfit", size: 16)!
            ]
        )
        returnKeyType = .done
        self.delegate = self
    }
    
    // 重写 textRect(forBounds:) 方法，控制文本的区域
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = bounds.inset(by: textInsets)
        
        // 如果有 leftView，调整文本区域，textInsets.left 为文本与 leftView 之间的间距
        if let leftView = leftView, leftView.isHidden == false {
            let leftViewRect = leftViewRect(forBounds: bounds)
            rect.size.width -= leftViewRect.width
            rect.origin.x = leftViewRect.maxX + textInsets.left
        }
        
        // 如果有 rightView，调整文本区域，textInsets.right 为文本与 rightView 之间的间距
        if let rightView = rightView, rightView.isHidden == false {
            let rightViewRect = rightViewRect(forBounds: bounds)
            rect.size.width -= rightViewRect.width
        }
        
        return rect
    }
    
    // 重写 editingRect(forBounds:) 方法，控制编辑时文本的区域
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}

extension TextFieldView : UITextFieldDelegate {
    
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
            if invalidCharacters.firstIndex(of: chr) == nil {
                validCharacters.append(chr)
            }
        }
        return validCharacters
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let shouldChange = textFieldViewDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string)
        if shouldChange == false {
            return false
        }
        
        if format == nil && (textField.text?.count ?? 0) + string.count <= maxLength {
            return true
        }
        
        let oldText = textField.text ?? ""
        var newText = ""
        if range.lowerBound == oldText.count {
            newText = "\(oldText)\(string)"
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
        textField.sendActions(for: .editingChanged)
        return false
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(false)
        let shouldReturn = textFieldViewDelegate?.textFieldShouldReturn?(textField)
        return shouldReturn ?? false
    }
    
   
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let shouldBeginEditing = textFieldViewDelegate?.textFieldShouldBeginEditing?(textField)
        return shouldBeginEditing ?? true
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldViewDelegate?.textFieldDidBeginEditing?(textField)
    }

  
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let shouldEndEditing = textFieldViewDelegate?.textFieldShouldEndEditing?(textField)
        return shouldEndEditing ?? true
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldViewDelegate?.textFieldDidEndEditing?(textField)
    }

    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textFieldViewDelegate?.textFieldDidEndEditing?(textField, reason: reason)
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        textFieldViewDelegate?.textFieldDidChangeSelection?(textField)
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let shouldClear = textFieldViewDelegate?.textFieldShouldClear?(textField)
        return shouldClear ?? true
    }

    @available(iOS 16.0, *)
    func textField(_ textField: UITextField, editMenuForCharactersIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
        textFieldViewDelegate?.textField?(textField, editMenuForCharactersIn: range, suggestedActions: suggestedActions)
    }

    @available(iOS 16.0, *)
    func textField(_ textField: UITextField, willPresentEditMenuWith animator: any UIEditMenuInteractionAnimating) {
        textFieldViewDelegate?.textField?(textField, willPresentEditMenuWith: animator)
    }

    @available(iOS 16.0, *)
    func textField(_ textField: UITextField, willDismissEditMenuWith animator: any UIEditMenuInteractionAnimating) {
        textFieldViewDelegate?.textField?(textField, willDismissEditMenuWith: animator)
    }
}
