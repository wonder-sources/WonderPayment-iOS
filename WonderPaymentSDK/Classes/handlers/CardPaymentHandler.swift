//
//  CardPaymentHandler.swift
//  PaymentSDK
//
//  Created by X on 2024/3/11.
//

import Foundation

class CardPaymentHandler : PaymentHander {
    func pay(intent: PaymentIntent, delegate: PaymentDelegate) {
        delegate.onProcessing()
        
        PaymentService.payOrder(intent: intent) { result, error in
            
            func checkIfValid(transaction: Transaction, callback: @escaping (Bool) -> Void) {
                if let url = transaction._3ds?.redirectUrl {
                    Loading.dismiss() { _ in
                        let browserController = BrowserViewController()
                        browserController.modalPresentationStyle = .fullScreen
                        browserController.url = url
                        browserController.finishedCallback = { result in
                            callback(result as? Bool ?? false)
                        }
                        UIViewController.current()?.present(browserController, animated: true)
                    }
                } else {
                    callback(true)
                }
            }
            
            if let transaction = result?.transaction, transaction.isPending {
                checkIfValid(transaction: transaction) {
                    valid in
                    if !valid {
                        delegate.onFinished(intent: intent, result: result, error: ErrorMessage._3dsVerificationError)
                        return
                    }
                    delegate.onProcessing()
                    PaymentService.loopForResult(uuid: transaction.uuid, orderNum: intent.orderNumber) {
                        result, error in
                        delegate.onFinished(intent: intent, result: result, error: error)
                    }
                }
            } else {
                delegate.onFinished(intent: intent, result: result, error: error)
            }
        }
    }
}
