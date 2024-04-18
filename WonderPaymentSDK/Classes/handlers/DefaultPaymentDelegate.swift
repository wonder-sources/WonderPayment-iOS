//
//  NoUIPaymentDelegate.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/3/14.
//

import Foundation

class DefaultPaymentDelegate : PaymentDelegate {
    
    let callback: PaymentResultCallback
    
    init(callback: @escaping PaymentResultCallback) {
        self.callback = callback
    }
    
    func onProcessing() {
        
    }
    
    func onInterrupt(intent: PaymentIntent) {
    
    }
    
    func onFinished(intent: PaymentIntent, result: PayResult?, error: ErrorMessage?) {
        var paymentResult = PaymentResult(status: .canceled)
        if let error = error {
            paymentResult = PaymentResult(status: .failed, code: error.code, message: error.message)
        }
        if let transaction = result?.transaction, transaction.success {
            paymentResult = PaymentResult(status: .completed)
        }
        callback(paymentResult)
    }
    
    func onCanceled() {
        callback(PaymentResult(status: .canceled))
    }
    
}
