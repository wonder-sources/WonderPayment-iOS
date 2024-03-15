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
        request.merchantIdentifier = merchantIdentifier
        request.supportedNetworks = networks
        request.merchantCapabilities = [.capability3DS, .capabilityEMV]
        request.countryCode = WonderPayment.paymentConfig.applePay?.countryCode ?? ""
        request.currencyCode = intent.currency
        let source = WonderPayment.paymentConfig.source
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: source, amount: NSDecimalNumber(value: intent.amount))
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
                
                // Token给到后端进行实际支付
                PaymentService.payOrder(
                    amount: intent.amount,
                    paymentMethod: PaymentMethodType.applePay.rawValue,
                    paymentData:  ["merchant_identifier": merchantIdentifier, "token_base64": token],
                    transactionType: intent.transactionType,
                    orderNum: intent.orderNumber,
                    businessId: WonderPayment.paymentConfig.businessId
                ) {
                    result, error in
                    
                    if (error != nil) {
                        completion?(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                        delegate.onFinished(intent: intent, result: result, error: error)
                        return
                    }
                    
                    // ApplePay显示成功
                    completion?(PKPaymentAuthorizationResult(status: .success, errors: nil))
                    
                    let orderNumber = intent.orderNumber
                    let businessId = WonderPayment.paymentConfig.businessId
                    if let result = result, let isPending = result.isPending, isPending {
                        delegate.onProcessing()
                        PaymentService.loopForResult(uuid: result.uuid!, orderNum: orderNumber, businessId: businessId) {
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
