//
//  KeyValueItem.swift
//  PaymentSDK
//
//  Created by X on 2024/3/6.
//

import Foundation

class KeyValueItem : TGLinearLayout {
    
    var key: String = "" {
        didSet {
            keyLabel.text = key
        }
    }
    var value: String = "" {
        didSet {
            valueLabel.text = value
        }
    }
    var valueIcon: UIImage? {
        didSet {
            valueIconView.image = valueIcon
        }
    }
    
    lazy var keyLabel = Label(key, style: .secondary)
    lazy var valueLabel = Label(value, style: .primary)
    lazy var valueIconView = UIImageView()
    
    convenience init(key: String, value: String, valueIcon: UIImage? = nil) {
        self.init(frame: .zero, orientation: .horz)
        self.key = key
        self.value = value
        self.valueIcon = valueIcon
        self.initView()
    }
    
//    private func initView() {
//        self.tg_width.equal(.fill)
//        self.tg_height.equal(.wrap)
//        
//        keyLabel.tg_width.equal(.wrap)
//        keyLabel.tg_height.equal(.wrap)
//        keyLabel.tg_right.equal(20)
//        addSubview(keyLabel)
//        
//         
//        valueIconView.image = valueIcon
//        valueIconView.tg_left.equal(100%)
//        valueIconView.tg_right.equal(4)
//        valueIconView.tg_width.equal(.wrap)
//        valueIconView.tg_height.equal(.wrap)
//        valueIconView.contentMode = .scaleAspectFit
//        addSubview(valueIconView)
//        
//        valueLabel.tg_height.equal(.wrap)
//        //let maxWidth = UIScreen.main.bounds.width / 2 - 62
//        valueLabel.tg_width.equal(.wrap)//.max(maxWidth)
//        valueLabel.textAlignment = .right
//        addSubview(valueLabel)
//    }
    
    private func initView() {
        self.tg_width.equal(.fill)
        self.tg_height.equal(.wrap)
        
        keyLabel.tg_width.equal(.wrap)
        keyLabel.tg_height.equal(.wrap)
        keyLabel.tg_right.equal(20)
        addSubview(keyLabel)
        
        if let icon = valueIcon {
            valueIconView.image = icon
            valueIconView.tg_left.equal(100%)
            valueIconView.tg_right.equal(4)
            valueIconView.tg_width.equal(.wrap)
            valueIconView.tg_height.equal(.wrap)
            valueIconView.contentMode = .scaleAspectFit
            valueIconView.tg_centerY.equal(0)
            addSubview(valueIconView)
        }
        
        valueLabel.tg_height.equal(.wrap)
        valueLabel.tg_width.equal(valueIcon == nil ? .fill : .wrap)
        valueLabel.textAlignment = .right
       
        addSubview(valueLabel)
    }
}
