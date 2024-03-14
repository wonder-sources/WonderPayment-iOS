//
//  FormTextFieldView.swift
//  PaymentSDK
//
//  Created by X on 2024/3/13.
//

import Foundation
import TangramKit
import QMUIKit

class FormTextFieldView : TGLinearLayout {
    
    typealias Validator = (String?) -> String?
    
    let textField: TextFieldView
    lazy var titleLabel = Label("", style: .secondary)
    lazy var errorLabel = Label("", color: WonderPayment.uiConfig.errorColor)
    let errorTextAlignment: NSTextAlignment
    var error: String? {
        didSet {
            errorLabel.text = error
            textField.layer.borderWidth = error == nil ? 0 : 2
            errorLabel.isHidden = error == nil
        }
    }
    var validator: Validator?
    
    init(
        title: String = "",
         placeholder: String = "",
         keyboardType: UIKeyboardType = .default,
         maxLength: UInt = UInt.max,
         leftView: UIView? = nil,
         format: String? = nil,
         errorTextAlignment: NSTextAlignment = .left
    ) {
        self.textField = TextFieldView(placeholder: placeholder, keyboardType: keyboardType, maxLength: maxLength, leftView: leftView, format: format)
        self.errorTextAlignment = errorTextAlignment
        super.init(frame: .zero, orientation: .vert)
        self.titleLabel.text = title
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.tg_width.equal(.fill)
        self.tg_height.equal(.wrap)
        
        titleLabel.tg_width.equal(.wrap)
        titleLabel.tg_height.equal(.wrap)
        addSubview(titleLabel)
        
        textField.tg_top.equal(4)
        textField.layer.borderWidth = 0
        textField.layer.borderColor = WonderPayment.uiConfig.errorColor.cgColor
        addSubview(textField)
        
        errorLabel.tg_width.equal(.fill)
        errorLabel.tg_height.equal(.wrap)
        errorLabel.tg_top.equal(4)
        errorLabel.textAlignment = errorTextAlignment
        addSubview(errorLabel)
        
        textField.delegate = self
    }
    
    var isValid: Bool {
        return validator?(textField.text) == nil
    }
}

extension FormTextFieldView: QMUITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        error = validator?(textField.text)
    }
}
