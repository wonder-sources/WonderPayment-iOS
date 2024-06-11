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
        Loading.show(style: .fullScreen)
    }
    
    func onInterrupt(intent: PaymentIntent) {
        Loading.dismiss()
    }
    
    func onFinished(intent: PaymentIntent, result: PayResult?, error: ErrorMessage?) {
        Loading.dismiss()
        var paymentResult = PaymentResult(status: .canceled)
        if let error = error {
            paymentResult = PaymentResult(status: .failed, code: error.code, message: error.message)
        }
        if let transaction = result?.transaction {
            if transaction.success {
                paymentResult = PaymentResult(status: .completed)
            } else {
                let paymentData = DynamicJson(value: transaction.paymentData)
                let code = paymentData["resp_code"].string
                let message = paymentData["resp_msg"].string
                paymentResult = PaymentResult(status: .failed, code: code, message: message)
            }
        }
        callback(paymentResult)
    }
    
    func onCanceled() {
        callback(PaymentResult(status: .canceled))
    }
    
}
