//
//  UnionPayHandler.swift
//  PaymentSDK
//
//  Created by X on 2024/3/11.
//

import Foundation

class UPPaymentHandler : PaymentHander {
    
    func pay(intent: PaymentIntent, delegate: PaymentDelegate) {
        delegate.onProcessing()
        
        PaymentService.payOrder(intent: intent) {
            result, error in
            if let transaction = result?.transaction
            {
                let json = DynamicJson.from(transaction.acquirerResponseBody)
                guard let paymentString = json["unionpay_wallet"]["in_app"]["payinfo"].string else {
                    delegate.onFinished(intent: intent, result: result, error: .dataFormatError)
                    return
                }
                guard let viewController = UIViewController.current() else {
                    delegate.onFinished(intent: intent, result: result, error: .unknownError)
                    return
                }
                delegate.onInterrupt(intent: intent)
                UPPaymentControl.default().startPay(paymentString, fromScheme: WonderPayment.paymentConfig.scheme, mode: "00", viewController: viewController)
                WonderPayment.unionPayCallback = { data in
                    let code = data["code"] as? String
                    let data = data["data"]
                    if code == "success" {
                        let orderNum = intent.orderNumber
                        delegate.onProcessing()
                        PaymentService.loopForResult(uuid: transaction.uuid, orderNum: orderNum) {
                            result, error in
                            delegate.onFinished(intent: intent, result: result, error: error)
                        }
                    } else if code == "fail" {
                        delegate.onFinished(intent: intent, result: nil, error: .unknownError)
                    } else if code == "cancel" {
                        delegate.onCanceled()
                    }
                }
                
            } else {
                delegate.onFinished(intent: intent, result: result, error: error)
            }
        }
    }

}
