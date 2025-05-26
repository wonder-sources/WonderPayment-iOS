//
//  FPSPaymentHandler.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/7/15.
//

import Foundation

class FPSPaymentHandler : PaymentHander {
    
    func pay(intent: PaymentIntent, delegate: PaymentDelegate) {
        delegate.onProcessing()
        
        intent.paymentMethod?.arguments = [
            "fps": [
                "amount": "\(intent.amount)",
                "in_app":[:],
            ]
        ]
        
        PaymentService.payOrder(intent: intent) {
            result, error in
            if let transaction = result?.transaction
            {
                let json = DynamicJson.from(transaction.acquirerResponseBody)
                guard let payload = json["fps"]["in_app"]["payinfo"].string else {
                    delegate.onFinished(intent: intent, result: result, error: .dataFormatError)
                    return
                }
                
                delegate.onInterrupt(intent: intent)
                
                let scheme = WonderPayment.paymentConfig.fromScheme
                let paymentString = "https://fps.wonder.today/fps?payload=\(payload.base64)"
                
                let dialog = FPSDialog()
                dialog.show()
                dialog.onSelected = { bankApp in
                    guard let url = URL(string: "\(bankApp.link!)?pay_req_obj=\(paymentString)&callback=\(scheme)://fps") else {
                        return
                    }
                    UIApplication.shared.open(url, options: [:])
                    WonderPayment.fpsCallback = { result in
                        if result["is_successful"] as? String != "1" {
                            return
                        }
                        dialog.dismiss()
                        let orderNum = intent.orderNumber
                        delegate.onProcessing()
                        PaymentService.loopForResult(uuid: transaction.uuid, orderNum: orderNum) {
                            result, error in
                            delegate.onFinished(intent: intent, result: result, error: error)
                        }
                    }
                }
                
            } else {
                delegate.onFinished(intent: intent, result: result, error: error)
            }
        }
    }
    
}
