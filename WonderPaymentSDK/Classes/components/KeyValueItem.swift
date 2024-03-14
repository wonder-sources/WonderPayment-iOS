//
//  KeyValueItem.swift
//  PaymentSDK
//
//  Created by X on 2024/3/6.
//

import Foundation
import TangramKit

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
    
    lazy var keyLabel = Label(key, style: .secondary)
    lazy var valueLabel = Label(value, style: .primary)
    
    convenience init(key: String, value: String) {
        self.init(frame: .zero, orientation: .horz)
        self.key = key
        self.value = value
        self.initView()
    }
    
    private func initView() {
        self.tg_width.equal(.fill)
        self.tg_height.equal(.wrap)
        
        keyLabel.tg_width.equal(.wrap)
        keyLabel.tg_height.equal(.wrap)
        addSubview(keyLabel)
        
        valueLabel.tg_left.equal(16)
        valueLabel.textAlignment = .right
        valueLabel.tg_width.equal(100%)
        valueLabel.tg_height.equal(.wrap)
        addSubview(valueLabel)
    }
}
