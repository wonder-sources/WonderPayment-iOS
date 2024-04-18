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
    
    var displayStyle: DisplayStyle
    var previewMode: Bool
    var radioButton: RadioButton?
    
    override var isSelected: Bool {
        didSet {
            radioButton?.isSelected = isSelected
        }
    }
    
    var method: PaymentMethod?
    
    init(displayStyle: DisplayStyle = .oneClick, previewMode: Bool = false) {
        self.displayStyle = displayStyle
        self.previewMode = previewMode
        super.init(frame: .zero)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.tg_height.equal(56)
        self.tg_width.equal(.fill)
        backgroundColor = WonderPayment.uiConfig.secondaryButtonBackground
        layer.cornerRadius = min(WonderPayment.uiConfig.borderRadius, 28)
        
        if displayStyle == .confirm || previewMode {
            
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
            
            let label = Label("Apple Pay", size: 16, fontStyle: .medium)
            label.textColor = WonderPayment.uiConfig.secondaryButtonColor
            label.tg_left.equal(8)
            label.tg_width.equal(.wrap)
            label.tg_height.equal(.wrap)
            label.tg_centerY.equal(0)
            child.addSubview(label)
            
            if displayStyle == .confirm {
                radioButton = RadioButton(style: .radio)
                radioButton!.tg_left.equal(100%)
                radioButton!.tg_width.equal(.wrap)
                radioButton!.tg_height.equal(.wrap)
                radioButton!.tg_centerY.equal(0)
                child.addSubview(radioButton!)
            } else if previewMode {
                let imageView = UIImageView(image: "arrow_right".svg)
                imageView.tg_centerY.equal(0)
                imageView.tg_left.equal(100%)
                child.addSubview(imageView)
            }
            
            
            layer.borderWidth = 1
            layer.borderColor = WonderPayment.uiConfig.secondaryButtonColor.cgColor
        } else {
            self.backgroundColor = WonderPayment.uiConfig.primaryButtonBackground
            self.setImage("ApplePay".svg, for: .normal)
        }
    }
}
