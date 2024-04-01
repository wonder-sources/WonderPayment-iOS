//
//  ApplePayButton.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/3/15.
//

import Foundation
import QMUIKit
import TangramKit

class ApplePayButton : QMUIButton, MethodItemView {
    
    var displayStyle: DisplayStyle = .oneClick
    var radioButton: RadioButton?
    
    override var isSelected: Bool {
        didSet {
            radioButton?.isSelected = isSelected
        }
    }
    
    var method: PaymentMethod?
    
    convenience init(displayStyle: DisplayStyle = .oneClick) {
        self.init(frame: .zero)
        self.displayStyle = displayStyle
        self.initView()
    }
    
    private func initView() {
        self.tg_height.equal(56)
        self.tg_width.equal(.fill)
        layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        
        if displayStyle == .confirm {
            
            let child = TGLinearLayout(.horz)
            child.tg_padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            child.tg_width.equal(.fill)
            child.tg_height.equal(.fill)
            child.isUserInteractionEnabled = false
            addSubview(child)
            
            let icon = UIImageView(image: "ApplePay2".svg)
            icon.contentMode = .scaleAspectFit
            icon.tg_width.equal(48)
            icon.tg_height.equal(25)
            icon.tg_centerY.equal(0)
            child.addSubview(icon)
            
            let label = UILabel()
            label.text = "Apple Pay"
            label.font = UIFont(name: "Futura-Medium", size: 16)
            label.textColor = WonderPayment.uiConfig.secondaryButtonColor
            label.tg_left.equal(8)
            label.tg_width.equal(.wrap)
            label.tg_height.equal(.wrap)
            label.tg_centerY.equal(0)
            child.addSubview(label)
            
            radioButton = RadioButton(style: .radio)
            radioButton!.tg_left.equal(100%)
            radioButton!.tg_width.equal(.wrap)
            radioButton!.tg_height.equal(.wrap)
            radioButton!.tg_centerY.equal(0)
            child.addSubview(radioButton!)
            
            layer.borderWidth = 1
            layer.borderColor = WonderPayment.uiConfig.secondaryButtonColor.cgColor
        } else {
            self.backgroundColor = WonderPayment.uiConfig.primaryButtonBackground
            self.setImage("ApplePay".svg, for: .normal)
        }
    }
}
