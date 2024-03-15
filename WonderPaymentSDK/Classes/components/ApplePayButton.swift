//
//  ApplePayButton.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/3/15.
//

import Foundation
import QMUIKit
import TangramKit

class ApplePayButton : QMUIButton {
    
    var selectMode = false
    
    convenience init(selectMode: Bool = false) {
        self.init(frame: .zero)
        self.selectMode = selectMode
        self.initView()
    }
    
    private func initView() {
        self.tg_height.equal(56)
        self.tg_width.equal(.fill)
        layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        
        if selectMode {
            
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
            label.textColor = WonderPayment.uiConfig.primaryButtonColor
            label.tg_left.equal(8)
            label.tg_width.equal(.wrap)
            label.tg_height.equal(.wrap)
            label.tg_centerY.equal(0)
            child.addSubview(label)
            
            let radioButton = RadioButton(style: .radio)
            radioButton.tg_left.equal(100%)
            radioButton.tg_width.equal(.wrap)
            radioButton.tg_height.equal(.wrap)
            radioButton.tg_centerY.equal(0)
            child.addSubview(radioButton)
            
            layer.borderWidth = 1
            layer.borderColor = WonderPayment.uiConfig.primaryButtonColor.cgColor
        } else {
            self.backgroundColor = WonderPayment.uiConfig.secondaryButtonBackground
            self.setImage("ApplePay".svg, for: .normal)
        }
    }
}
