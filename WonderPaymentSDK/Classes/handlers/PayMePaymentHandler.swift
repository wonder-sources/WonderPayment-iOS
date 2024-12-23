//
//  PayMePaymentHandler.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/8/13.
//

import Foundation



class PayMePaymentHandler : PaymentHander {
    
    func pay(intent: PaymentIntent, delegate: PaymentDelegate) {
        delegate.onProcessing()
        
        let scheme = WonderPayment.paymentConfig.fromScheme
        let callbackUrl = "\(scheme)://payme"
        let successUrl = "\(scheme)://payme/success"
        let failUrl = "\(scheme)://payme/fail"
        intent.paymentMethod?.arguments = [
            "payme": [
                "amount": "\(intent.amount)",
                "in_app": [
                    "return_url": callbackUrl
                ],
                "success_url": successUrl,
                "fail_url": failUrl,
            ]
        ]
        
        PaymentService.payOrder(intent: intent) {
            result, error in
            if let transaction = result?.transaction
            {
                let json = DynamicJson.from(transaction.acquirerResponseBody)
                guard let paymentUrl = json["payme"]["in_app"]["payinfo"].string else {
                    delegate.onFinished(intent: intent, result: result, error: .dataFormatError)
                    return
                }
          
                
                guard let url = URL(string: paymentUrl) else {
                    delegate.onFinished(intent: intent, result: result, error: .dataFormatError)
                    return
                }
                
                delegate.onInterrupt(intent: intent)
                
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    if success {
                        WonderPayment.paymeCallback = { data in
                            let code = data["code"] as? Int
                            if code == 0 {
                                let orderNum = intent.orderNumber
                                delegate.onProcessing()
                                PaymentService.loopForResult(uuid: transaction.uuid, orderNum: orderNum) {
                                    result, error in
                                    delegate.onFinished(intent: intent, result: result, error: error)
                                }
                            } else {
                                delegate.onFinished(intent: intent, result: nil, error: ErrorMessage.unknownError)
                            }
                            
                        }
                    } else {
                        delegate.onFinished(intent: intent, result: result, error: .unknownError)
                    }
                })
                
            } else {
                delegate.onFinished(intent: intent, result: result, error: error)
            }
        }
    }
    
}
