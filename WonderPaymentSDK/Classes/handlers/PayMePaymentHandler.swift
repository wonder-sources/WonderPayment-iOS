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
        
        intent.paymentMethod?.arguments = [
            "payme": [
                "amount": "\(intent.amount)",
                "in_app": [:]
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
          
                let scheme = WonderPayment.paymentConfig.fromScheme
                guard let url = URL(string: "\(paymentUrl)?appSuccessCallback=\(scheme)://payme") else {
                    delegate.onFinished(intent: intent, result: result, error: .dataFormatError)
                    return
                }
                
                delegate.onInterrupt(intent: intent)
                
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    if success {
                        WonderPayment.paymeCallback = { _ in
                            let orderNum = intent.orderNumber
                            delegate.onProcessing()
                            PaymentService.loopForResult(uuid: transaction.uuid, orderNum: orderNum) {
                                result, error in
                                delegate.onFinished(intent: intent, result: result, error: error)
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
