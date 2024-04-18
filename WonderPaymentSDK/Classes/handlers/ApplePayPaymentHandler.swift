//
//  ApplePayPaymentHandler.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/3/15.
//

import Foundation
import PassKit

class ApplePayPaymentHandler: PaymentHander {
    
    func pay(intent: PaymentIntent, delegate: PaymentDelegate) {
        let networks: [PKPaymentNetwork] = [.visa, .masterCard, .amex, .discover, .JCB, .chinaUnionPay]
        let request = PKPaymentRequest()
        let merchantIdentifier = WonderPayment.paymentConfig.applePay?.merchantIdentifier ?? ""
        let merchantName = WonderPayment.paymentConfig.applePay?.merchantName ?? ""
        request.merchantIdentifier = merchantIdentifier
        request.supportedNetworks = networks
        request.merchantCapabilities = [.capability3DS, .capabilityEMV]
        request.countryCode = WonderPayment.paymentConfig.applePay?.countryCode ?? ""
        request.currencyCode = intent.currency
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: merchantName, amount: NSDecimalNumber(value: intent.amount))
        ]
        
        if let controller = PKPaymentAuthorizationViewController(paymentRequest: request) {
            controller.delegate = WonderPayment.applePayDelegate
            UIViewController.current()?.present(controller, animated: true, completion: nil)
            WonderPayment.applePayCallback = {
                token, completion in
                if token == nil {
                    delegate.onCanceled()
                    return
                }
                
                var modeArgs: NSDictionary?
                if (intent.transactionType == .preAuth) {
                    modeArgs = ["consume_mode": "pre_authorize"]
                }
                intent.paymentMethod?.arguments = [
                    "apple_pay": [
                        "amount": "\(intent.amount)",
                        "merchant_identifier": merchantIdentifier,
                        "token_base64": token,
                    ].merge(modeArgs)
                ]
                
                // Token给到后端进行实际支付
                PaymentService.payOrder(intent: intent) {
                    result, error in
                    
                    if (error != nil) {
                        completion?(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                        delegate.onFinished(intent: intent, result: nil, error: error)
                        return
                    }
                    
                    // ApplePay显示成功
                    completion?(PKPaymentAuthorizationResult(status: .success, errors: nil))
                    
                    let orderNumber = intent.orderNumber
                    if let transaction = result?.transaction, transaction.isPending {
                        delegate.onProcessing()
                        PaymentService.loopForResult(uuid: transaction.uuid, orderNum: orderNumber) {
                            result, error in
                            delegate.onFinished(intent: intent, result: result, error: error)
                        }
                    } else {
                        delegate.onFinished(intent: intent, result: result, error: error)
                    }
                }
            }
        } else {
            delegate.onCanceled()
        }
    }
}
