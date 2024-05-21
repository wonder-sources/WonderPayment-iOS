//
//  WechatPaymentHandler.swift
//  PaymentSDK
//
//  Created by X on 2024/3/12.
//

import Foundation

class WechatPaymentHandler : PaymentHander {
    
    func pay(intent: PaymentIntent, delegate: PaymentDelegate) {
        if !WXApi.isWXAppInstalled() {
            delegate.onFinished(intent: intent, result: nil, error: .unsupportedError)
            return
        }
        delegate.onProcessing()
        
        let appId = WonderPayment.paymentConfig.wechat?.appId
        intent.paymentMethod?.arguments = [
            "wechatpay": [
                "amount": "\(intent.amount)",
                "in_app": ["app_id": appId]
            ]
        ]
        
        PaymentService.payOrder(intent: intent) {
            result, error in
            if let transaction = result?.transaction
            {
                let json = DynamicJson.from(transaction.acquirerResponseBody)
                guard let paymentString = json["wechat_pay"]["in_app"]["payinfo"].string else {
                    delegate.onFinished(intent: intent, result: result, error: .dataFormatError)
                    return
                }
                
                let paymentArgs = DynamicJson.from(paymentString)
                let partnerId = paymentArgs["partnerid"].string ?? ""
                let prepayId = paymentArgs["prepay_id"].string ?? ""
                let package = paymentArgs["package"].string ?? ""
                let nonceStr = paymentArgs["nonceStr"].string ?? ""
                let timeStamp = paymentArgs["timeStamp"].string ?? ""
                let sign = paymentArgs["paySign"].string ?? ""
    
                let payReq = PayReq()
                payReq.partnerId = partnerId
                payReq.prepayId = prepayId
                payReq.package = package
                payReq.nonceStr = nonceStr
                payReq.timeStamp = UInt32(timeStamp) ?? 0
                payReq.sign = sign
            
                delegate.onInterrupt(intent: intent)
                WXApi.send(payReq)
                WonderPayment.wechatPayCallback = { data in
                    let code = data["code"] as? Int32
                    let message = data["message"] as? String
                    if code == 0 {
                        let orderNum = intent.orderNumber
                        delegate.onProcessing()
                        PaymentService.loopForResult(uuid: transaction.uuid, orderNum: orderNum) {
                            result, error in
                            delegate.onFinished(intent: intent, result: result, error: error)
                        }
                    } else if code == -2 {
                        delegate.onCanceled()
                    } else {
                        let errCode = "\(code ?? 100001)"
                        let errMessage = message ?? ""
                        delegate.onFinished(intent: intent, result: nil, error: ErrorMessage(code: errCode, message: errMessage))
                    }
                }
                
            } else {
                delegate.onFinished(intent: intent, result: nil, error: error)
            }
        }
    }
}

