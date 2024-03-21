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
    var selectMode: Bool = false
    var method: PaymentMethod?
    
    lazy var radioButton = RadioButton(style: selectMode ? .radio : .check, cancellable: false)
    
    override var isSelected: Bool {
        didSet {
            radioButton.isSelected = isSelected
        }
    }
    
    convenience init(icon: String, cardNumber: String, isSelected: Bool = false, selectMode: Bool = false) {
        self.init(frame: .zero, orientation: .horz)
        self.icon = icon
        self.cardNumber = cardNumber
        self.selectMode = selectMode
        self.isSelected = isSelected
        self.initView()
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
        
        let cardNumberLabel = Label(cardNumber)
        cardNumberLabel.tg_left.equal(8)
        cardNumberLabel.tg_height.equal(.wrap)
        cardNumberLabel.tg_width.equal(.fill)
        cardNumberLabel.tg_centerY.equal(0)
        addSubview(cardNumberLabel)
        
        radioButton.isSelected = isSelected
        radioButton.isUserInteractionEnabled = false
        radioButton.tg_width.equal(26)
        radioButton.tg_height.equal(26)
        radioButton.tg_centerY.equal(0)
        radioButton.tg_left.equal(16)
        addSubview(radioButton)
    }
}
