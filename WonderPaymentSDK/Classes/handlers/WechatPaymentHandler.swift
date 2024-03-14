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
                        let uuid = result.uuid
                        let orderNum = intent.orderNumber
                        let businessId = WonderPayment.paymentConfig.businessId
                        delegate.onProcessing()
                        PaymentService.loopForResult(uuid: uuid!, orderNum: orderNum, businessId: businessId) {
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
                delegate.onFinished(intent: intent, result: result, error: error)
            }
        }
    }
}

