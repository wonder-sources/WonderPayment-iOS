//
//  UnionPayHandler.swift
//  PaymentSDK
//
//  Created by X on 2024/3/11.
//

import Foundation

class UPPaymentHandler : PaymentHander {
    
    func pay(intent: PaymentIntent, delegate: PaymentDelegate) {
        let arguments = intent.paymentMethod?.arguments as? [String: Any?]
        let args = arguments ?? [:]
        delegate.onProcessing()
        PaymentService.payOrder(
            amount: intent.amount,
            paymentMethod: PaymentMethodType.unionPay.rawValue,
            paymentData: args,
            transactionType: intent.transactionType,
            orderNum: intent.orderNumber,
            businessId: WonderPayment.paymentConfig.businessId
        ) {
            result, error in
            if let result = result , let args = result.acquirerResponseBody {
                let json = DynamicJson.from(args)
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
                        let uuid = result.uuid
                        let orderNum = intent.orderNumber
                        let businessId = WonderPayment.paymentConfig.businessId
                        delegate.onProcessing()
                        PaymentService.loopForResult(uuid: uuid!, orderNum: orderNum, businessId: businessId) {
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
