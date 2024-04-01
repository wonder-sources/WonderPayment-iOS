//
//  Button.swift
//  PaymentSDK
//
//  Created by X on 2024/3/8.
//

import Foundation
import QMUIKit

class Button : QMUIButton {
    
    enum ButtonStyle {
        case primary, secondary
    }
    
    var style: ButtonStyle = .primary
    
    convenience init(title: String, image: UIImage? = nil, imageSpacing: CGFloat = 8, style: ButtonStyle = .primary) {
        self.init(frame: .zero)
        self.style = style
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
        spacingBetweenImageAndTitle = imageSpacing
        initView()
    }
    
    private func initView() {
        let backgroundColor: UIColor
        let titleColor: UIColor
        
        switch(style) {
        case.primary:
            backgroundColor = WonderPayment.uiConfig.secondaryButtonBackground
            titleColor = WonderPayment.uiConfig.secondaryButtonColor
            layer.borderWidth = 1
        case .secondary:
            backgroundColor = WonderPayment.uiConfig.primaryButtonBackground
            titleColor = WonderPayment.uiConfig.primaryButtonColor
        }
        
        self.backgroundColor = backgroundColor
        setTitleColor(titleColor, for: .normal)
        layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        titleLabel?.font = UIFont(name: "Futura-Medium", size: 16)
        tg_height.equal(52)
        tg_width.equal(.fill)
    }
}
