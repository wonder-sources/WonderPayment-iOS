//
//  CardItemView.swift
//  PaymentSDK
//
//  Created by X on 2024/3/9.
//

import Foundation
import TangramKit

class CardItemView : TGLinearLayout, MethodItemView {
    
    var icon: String = ""
    var cardNumber: String = ""
    var displayStyle: DisplayStyle = .oneClick
    var method: PaymentMethod?
    var previewMode: Bool
    
    var radioButton: RadioButton?
    
    override var isSelected: Bool {
        didSet {
            radioButton?.isSelected = isSelected
        }
    }
    
    init(icon: String, cardNumber: String, isSelected: Bool = false, displayStyle: DisplayStyle = .oneClick, previewMode: Bool = false) {
        self.icon = icon
        self.cardNumber = cardNumber
        self.displayStyle = displayStyle
        self.previewMode = previewMode
        super.init(frame: .zero, orientation: .horz)
        self.isSelected = isSelected
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        tg_height.equal(56)
        tg_width.equal(.fill)
        
        let iconView = UIImageView()
        if !icon.isEmpty {
            iconView.image = icon.svg
            iconView.contentMode = .scaleAspectFit
        }
        iconView.tg_width.equal(26)
        iconView.tg_height.equal(24)
        iconView.tg_centerY.equal(0)
        addSubview(iconView)
        
        let cardNumberLabel = Label(cardNumber, size: 16, fontStyle: .medium)
        cardNumberLabel.textColor = WonderPayment.uiConfig.secondaryButtonColor
        cardNumberLabel.tg_left.equal(8)
        cardNumberLabel.tg_height.equal(.wrap)
        cardNumberLabel.tg_width.equal(.fill)
        cardNumberLabel.tg_centerY.equal(0)
        addSubview(cardNumberLabel)
        
        if previewMode {
            let imageView = UIImageView(image: "arrow_right".svg)
            imageView.tg_centerY.equal(0)
            addSubview(imageView)
        } else {
            radioButton = RadioButton(style: displayStyle == .confirm ? .radio : .check, cancellable: false)
            radioButton!.isSelected = isSelected
            radioButton!.isUserInteractionEnabled = false
            radioButton!.tg_width.equal(26)
            radioButton!.tg_height.equal(26)
            radioButton!.tg_centerY.equal(0)
            radioButton!.tg_left.equal(16)
            addSubview(radioButton!)
        }
        
    }
}
