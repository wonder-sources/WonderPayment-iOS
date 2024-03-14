//
//  AlipayPaymentHandler.swift
//  PaymentSDK
//
//  Created by X on 2024/3/12.
//

import Foundation


class AlipayPaymentHandler : PaymentHander {
    
    func pay(intent: PaymentIntent, delegate: PaymentDelegate) {
        let arguments = intent.paymentMethod?.arguments as? [String: Any?]
        let args = arguments ?? [:]
        delegate.onProcessing()
        PaymentService.payOrder(amount: intent.amount, paymentMethod: PaymentMethodType.alipay.rawValue, paymentData: args, orderNum: intent.orderNumber, businessId: WonderPayment.paymentConfig.businessId) { result, error in
            if let result = result , let args = result.acquirerResponseBody {
                let json = DynamicJson.from(args)
                guard let paymentString = json["alipay"]["in_app"]["payinfo"].string else {
                    delegate.onFinished(intent: intent, result: result, error: .dataFormatError)
                    return
                }
          
                delegate.onInterrupt(intent: intent)
                
                AlipaySDK.defaultService().payOrder(paymentString, fromScheme: WonderPayment.paymentConfig.scheme) { 
                    data in
                    //WebView 回调
                    let resultStatus = data?["resultStatus"]
                    let memo = data?["memo"]
                    let callbackData: [String: Any?] = ["resultStatus": resultStatus, "memo": memo]
                    WonderPayment.alipayCallback?(callbackData)
                }
                
                WonderPayment.alipayCallback = { data in
                    let resultStatus = data["resultStatus"] as? String
                    let memo = data["memo"] as? String
                    if resultStatus == "9000" {
                        let uuid = result.uuid
                        let orderNum = intent.orderNumber
                        let businessId = WonderPayment.paymentConfig.businessId
                        delegate.onProcessing()
                        PaymentService.loopForResult(uuid: uuid!, orderNum: orderNum, businessId: businessId) {
                            result, error in
                            delegate.onFinished(intent: intent, result: result, error: error)
                        }
                    } else {
                        if resultStatus == "6001" {
                            delegate.onCanceled()
                        } else {
                            let error = ErrorMessage(code: "\(resultStatus ?? "")", message: memo ?? "")
                            delegate.onFinished(intent: intent, result: nil, error: error)
                        }
                    }
                }
                
            } else {
                delegate.onFinished(intent: intent, result: result, error: error)
            }
        }
    }
    
}
