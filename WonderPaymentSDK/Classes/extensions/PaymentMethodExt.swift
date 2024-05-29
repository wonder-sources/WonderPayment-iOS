//
//  PaymentMethodExt.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/4/17.
//

import Foundation

extension PaymentMethod {
    
    var name: String {
        switch (self.type) {
        case .applePay:
            return "Apple Pay"
        case .alipay:
            return "alipay".i18n
        case .alipayHK:
            return "alipayHK".i18n
        case .wechat:
            return "wechatPay".i18n
        case .unionPay:
            return "unionPay".i18n
        case .octopus:
            return "octopus".i18n
        default:
            return ""
        }
    }
    
    var icon: String {
        switch (self.type) {
        case .applePay:
            return "ApplePay"
        case .alipay:
            return "Alipay"
        case .alipayHK:
            return "Alipay"
        case .wechat:
            return "WechatPay"
        case .unionPay:
            return "UnionPay"
        case .octopus:
            return "Octopus"
        default:
            return ""
        }
    }
}
