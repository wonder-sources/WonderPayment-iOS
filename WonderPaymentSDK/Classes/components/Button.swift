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
        case secondary, primary
    }
    
    var style: ButtonStyle = .secondary
    
    convenience init(title: String, image: UIImage? = nil, imageSpacing: CGFloat = 8, style: ButtonStyle = .secondary) {
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
        case.secondary:
            backgroundColor = WonderPayment.uiConfig.secondaryButtonBackground
            titleColor = WonderPayment.uiConfig.secondaryButtonColor
            layer.borderWidth = 1
        case .primary:
            backgroundColor = WonderPayment.uiConfig.primaryButtonBackground
            titleColor = WonderPayment.uiConfig.primaryButtonColor
        }
        
        self.backgroundColor = backgroundColor
        setTitleColor(titleColor, for: .normal)
        layer.cornerRadius = min(WonderPayment.uiConfig.borderRadius, 26)
        titleLabel?.font = UIFont(name: "Outfit-Medium", size: 16)
        tg_height.equal(52)
        tg_width.equal(.fill)
    }
}
