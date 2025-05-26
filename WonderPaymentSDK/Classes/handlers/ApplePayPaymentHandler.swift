//
//  ApplePayPaymentHandler.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/3/15.
//

import Foundation
import PassKit

class ApplePayPaymentHandler: PaymentHander {
    
    func mapNetwork(string: String) -> PKPaymentNetwork? {
        var network: PKPaymentNetwork?
        switch(string) {
        case "diners":
            network = .discover
        case "jcb":
            network = .JCB
        case "cup":
            network = .chinaUnionPay
        case "discover":
            network = .discover
        case "mastercard":
            network = .masterCard
        case "amex":
            network = .amex
        case "visa":
            network = .visa
        default: ()
        }
        return network
    }
    
    func pay(intent: PaymentIntent, delegate: PaymentDelegate) {
        var supportNetworks = [PKPaymentNetwork]()
        if let supportCards = intent.paymentMethod?.arguments?["supportCards"] as? Array<String> {
            supportNetworks = supportCards.compactMap(mapNetwork)
        }
        let request = PKPaymentRequest()
        let merchantIdentifier = WonderPayment.paymentConfig.applePay?.merchantIdentifier ?? ""
        let merchantName = WonderPayment.paymentConfig.applePay?.merchantName ?? ""
        request.merchantIdentifier = merchantIdentifier
        request.supportedNetworks = supportNetworks
        request.merchantCapabilities = [.capability3DS, .capabilityEMV]
        request.countryCode = WonderPayment.paymentConfig.applePay?.countryCode ?? ""
        request.currencyCode = intent.currency
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: merchantName, amount: NSDecimalNumber(value: intent.amount))
        ]
        
        let copiedIntent = intent.copy()
        if let controller = PKPaymentAuthorizationViewController(paymentRequest: request) {
            controller.delegate = WonderPayment.applePayDelegate
            UIViewController.current()?.present(controller, animated: true, completion: nil)
            WonderPayment.applePayCallback = {
                token, completion in
                guard let token else {
                    delegate.onCanceled()
                    return
                }
                
                let applePayArgs: NSMutableDictionary = [
                    "amount": "\(intent.amount)",
                    "merchant_identifier": merchantIdentifier,
                    "token_base64": token,
                ]
                
                let paymentArgs: NSMutableDictionary = [
                    "apple_pay": applePayArgs
                ]
                
                if (copiedIntent.isOnlyPreAuth || copiedIntent.preAuthModeForSales) {
                    applePayArgs["consume_mode"] = "pre_authorize"
                    paymentArgs["allow_over_completion"] = true
                }
                copiedIntent.paymentMethod?.arguments = paymentArgs
                
                // Token给到后端进行实际支付
                PaymentService.payOrder(intent: copiedIntent) {
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
