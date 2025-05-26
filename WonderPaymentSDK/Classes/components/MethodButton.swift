//
//  MethodButton.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/3/18.
//

import Foundation

class MethodButton : Button, MethodItemView {
    var image: String
    var title: String
    var displayStyle: DisplayStyle
    var method: PaymentMethod?
    var previewMode: Bool
    
    var radioButton: RadioButton?
    
    var canSelect: Bool {
        return displayStyle == .confirm && !previewMode
    }
    
    override var isSelected: Bool {
        didSet {
            radioButton?.isSelected = isSelected
        }
    }
    
    init(image: String, title: String, displayStyle: DisplayStyle = .oneClick, previewMode: Bool = false) {
        self.image = image
        self.title = title
        self.displayStyle = displayStyle
        self.previewMode = previewMode
        super.init(frame: .zero)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        backgroundColor = WonderPayment.uiConfig.secondaryButtonBackground
        layer.borderWidth = 1
        layer.cornerRadius = min(WonderPayment.uiConfig.borderRadius, 28)
        layer.borderColor = WonderPayment.uiConfig.borderColor.cgColor
        tg_width.equal(.fill)
        tg_height.equal(56)
        
        let child = TGLinearLayout(.horz)
        child.tg_padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        child.tg_width.equal(.fill)
        child.tg_height.equal(.fill)
        child.isUserInteractionEnabled = false
        addSubview(child)
        
        let icon = UIImageView(image: image.svg)
        icon.contentMode = .scaleAspectFit
        icon.tg_width.equal(48)
        icon.tg_height.equal(25)
        icon.tg_centerY.equal(0)
        child.addSubview(icon)
        
        let label = Label(title, size: 16, fontStyle: .medium)
        label.textColor = WonderPayment.uiConfig.secondaryButtonColor
        label.tg_left.equal(8)
        label.tg_width.equal(.wrap)
        label.tg_height.equal(.wrap)
        label.tg_centerY.equal(0)
        child.addSubview(label)
        
        if previewMode {
            let tintColor = WonderPayment.uiConfig.primaryButtonBackground
            let imageView = UIImageView(image: "arrow_right".svg?.withTintColor(tintColor))
            imageView.tg_centerY.equal(0)
            imageView.tg_left.equal(100%)
            child.addSubview(imageView)
        } else if (displayStyle == .confirm) {
            radioButton = RadioButton(style: .radio)
            radioButton!.tg_left.equal(100%)
            radioButton!.tg_width.equal(24)
            radioButton!.tg_height.equal(24)
            radioButton!.tg_centerY.equal(0)
            child.addSubview(radioButton!)
        }
    }
}
