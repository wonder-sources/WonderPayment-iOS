//
//  MethodButton.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/3/18.
//

import Foundation
import QMUIKit
import TangramKit

class MethodButton : QMUIButton, MethodItemView {
    var image: String
    var title: String
    var selectMode: Bool
    var method: PaymentMethod?
    
    lazy var radioButton = RadioButton(style: .radio)
    
    override var isSelected: Bool {
        didSet {
            radioButton.isSelected = isSelected
        }
    }
    
    init(image: String, title: String, selectMode: Bool = false) {
        self.image = image
        self.title = title
        self.selectMode = selectMode
        super.init(frame: .zero)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        backgroundColor = WonderPayment.uiConfig.primaryButtonBackground
        layer.borderWidth = 1
        layer.cornerRadius = WonderPayment.uiConfig.borderRadius
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
        
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "Futura-Medium", size: 16)
        label.textColor = WonderPayment.uiConfig.primaryButtonColor
        label.tg_left.equal(8)
        label.tg_width.equal(.wrap)
        label.tg_height.equal(.wrap)
        label.tg_centerY.equal(0)
        child.addSubview(label)
        
        radioButton.tg_left.equal(100%)
        radioButton.tg_width.equal(.wrap)
        radioButton.tg_height.equal(.wrap)
        radioButton.tg_centerY.equal(0)
        child.addSubview(radioButton)
        
        if !selectMode {
            icon.tg_left.equal(100%)
            radioButton.alpha = 0
        }
    }
}
