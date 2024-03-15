//
//  CardPaymentHandler.swift
//  PaymentSDK
//
//  Created by X on 2024/3/11.
//

import Foundation

class CardPaymentHandler : PaymentHander {
    func pay(intent: PaymentIntent, delegate: PaymentDelegate) {
        let args = intent.paymentMethod?.arguments as? [String: Any?]
        let orderNumber = intent.orderNumber
        let businessId = WonderPayment.paymentConfig.businessId
        delegate.onProcessing()
        PaymentService.payOrder(
            amount: intent.amount,
            paymentMethod: PaymentMethodType.creditCard.rawValue,
            paymentData: args ?? [:], 
            transactionType: intent.transactionType, 
            orderNum: orderNumber,
            businessId: businessId
        ) { result, error in
            
            if let result = result, let isPending = result.isPending, isPending {
                PaymentService.loopForResult(uuid: result.uuid!, orderNum: orderNumber, businessId: businessId) {
                    result, error in
                    delegate.onFinished(intent: intent, result: result, error: error)
                }
            } else {
                delegate.onFinished(intent: intent, result: result, error: error)
            }
        }
    }
    
    deinit{
        print("CardPaymentHandler deinit")
    }
}
