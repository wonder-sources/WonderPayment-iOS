//
//  WechatPaymentHandler.swift
//  PaymentSDK
//
//  Created by X on 2024/3/12.
//

import Foundation

class WechatPaymentHandler : PaymentHander {
    func pay(intent: PaymentIntent, delegate: PaymentDelegate) {
        let arguments = intent.paymentMethod?.arguments as? [String: Any?]
        let args = arguments ?? [:]
        delegate.onProcessing()
        PaymentService.payOrder(amount: intent.amount, paymentMethod: PaymentMethodType.wechat.rawValue, paymentData: args, orderNum: intent.orderNumber, businessId: WonderPayment.paymentConfig.businessId) { result, error in
            if let result = result , let args = result.acquirerResponseBody {
                let json = DynamicJson.from(args)
                guard let paymentString = json["wechatpay"]["in_app"]["payinfo"].string else {
                    delegate.onFinished(intent: intent, result: result, error: .dataFormatError)
                    return
                }
          
                delegate.onInterrupt(intent: intent)
                
                let payReq = PayReq()
                
                WXApi.send(payReq)
                
            } else {
                delegate.onFinished(intent: intent, result: result, error: error)
            }
        }
    }
    
    
}


class WxDelegate: NSObject, WXApiDelegate {
    func onResp(_ resp: BaseResp) {
        if let resp = resp as? PayResp {
            
        }
    }
}
