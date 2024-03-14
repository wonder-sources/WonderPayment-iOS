//
//  Lable.swift
//  PaymentSDK
//
//  Created by X on 2024/3/6.
//

import QMUIKit



class Label : QMUILabel {
    
    enum LabelStyle {
        case primary, secondary
    }
    
    enum FontStyle : String {
        case normal = "Futura",
             medium = "Futura-Medium",
             bold = "Futura-Bold"
    }
    
    var color: UIColor = WonderPayment.uiConfig.primaryTextColor
    var style: LabelStyle = .primary
    var fontStyle: FontStyle = .normal
    var size: CGFloat = 16
    
    convenience init(_ text: String, style: LabelStyle = .primary, color: UIColor? = nil, size: CGFloat = 16, fontStyle: FontStyle = .normal) {
        self.init(frame: .zero)
        self.text = text
        self.style = style
        switch (style) {
        case .primary:
            self.color = WonderPayment.uiConfig.primaryTextColor
        case .secondary:
            self.color = WonderPayment.uiConfig.secondaryTextColor
        }
        self.color = color ?? self.color
        self.size = size
        self.fontStyle = fontStyle
        self.initView()
    }
    
    private func initView() {
        self.tg_width.equal(.wrap)
        self.tg_height.equal(.wrap)
        self.font = UIFont(name: fontStyle.rawValue, size: size)
        self.textColor = color
    }
}
