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
        
        var paymentArgs: [String:Any] = [:]
        let cardArgs = intent.paymentMethod?.arguments
        var modeArgs: NSDictionary?
        if (intent.isOnlyPreAuth || intent.preAuthModeForSales) {
            modeArgs = [
                "consume_mode": "pre_authorize",
            ]
            paymentArgs["allow_over_completion"] = true
        }
        let copiedIntent = intent.copy()
        if let token = cardArgs?["token"] as? String {
            paymentArgs["payment_token"] = [
                "amount": "\(intent.amount)",
                "token": token
            ].merge(modeArgs)
            copiedIntent.paymentMethod?.arguments = paymentArgs as NSDictionary
        } else {
            do {
                paymentArgs["credit_card"] = [
                    "amount": "\(intent.amount)",
                    "3ds": PaymentService._3dsConfig
                ].merge(cardArgs).merge(modeArgs)
                paymentArgs = try EncryptionUtil.encrypt(content: paymentArgs)
                copiedIntent.paymentMethod?.arguments = paymentArgs as NSDictionary
            } catch {
                let err = ErrorMessage(code: "E100004", message: error.localizedDescription)
                delegate.onFinished(intent: intent, result: nil, error: err)
                return
            }
        }
        
        PaymentService.payOrder(intent: copiedIntent) { result, error in
            
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
