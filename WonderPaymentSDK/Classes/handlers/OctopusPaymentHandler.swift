//
//  OctopusPaymentHandler.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/4/22.
//

import Foundation
//
//  AlipayPaymentHandler.swift
//  PaymentSDK
//
//  Created by X on 2024/3/12.
//

import Foundation



class OctopusPaymentHandler : PaymentHander {
    
    func isSecondDecimalPlaceNonZero(_ value: Double) -> Bool {
        let stringValue = String(format: "%.2f", value)
        if let dotIndex = stringValue.firstIndex(of: ".") {
            let secondDecimalIndex = stringValue.index(dotIndex, offsetBy: 2)
            let secondDecimalChar = stringValue[secondDecimalIndex]
            return secondDecimalChar != "0"
        }
        return false
    }
    
    func roundFirstDecimalPlaceUp(_ value: Double) -> Double {
        let roundedValue = ceil(value * 10) / 10
        return roundedValue
    }
    
    func checkIfNeedAdjustAmount(intent: PaymentIntent, completion: @escaping (Int) -> Void) {
        if isSecondDecimalPlaceNonZero(intent.amount) {
            let originalAmount = "\(intent.amount)\(intent.currency)"
            let roundedUpAmount = roundFirstDecimalPlaceUp(intent.amount)
            let adjustedAmount = "\(roundedUpAmount)\(intent.currency)"
            let dialog = AmountAdjustmentDialog(originalAmount: originalAmount, adjustedAmount: adjustedAmount)
            dialog.show(callback: completion)
        } else {
            completion(1)
        }
    }
    
    func pay(intent: PaymentIntent, delegate: PaymentDelegate) {
        let isInstalled = UIApplication.shared.canOpenURL(URL(string: "octopus://payment")!)
        if !isInstalled {
            delegate.onFinished(intent: intent, result: nil, error: .unsupportedError)
            return
        }
        
        
        checkIfNeedAdjustAmount(intent: intent) { result in
            if result == 0 {
                delegate.onCanceled()
                return
            }
            
            delegate.onProcessing()
            
            let newAmount = self.roundFirstDecimalPlaceUp(intent.amount)
            let v1 = Decimal(string: "\(newAmount)") ?? 0
            let v2 = Decimal(string: "\(intent.amount)") ?? 0
            let stringValue = NSDecimalNumber(decimal: v1 - v2).stringValue
            let rounding = Double(stringValue) ?? 0
            var lineItems = intent.lineItems ?? []
            lineItems.append(LineItem(purchasableType: "Rounding", quantity: 1, price: rounding, total: rounding))
            intent.lineItems = lineItems
            intent.amount = newAmount
            
            intent.paymentMethod?.arguments = [
                "octopus": [
                    "amount": "\(intent.amount)",
                    "in_app": [:]
                ]
            ]
            
            PaymentService.payOrder(intent: intent) {
                result, error in
                if let transaction = result?.transaction
                {
                    let json = DynamicJson.from(transaction.acquirerResponseBody)
                    guard let paymentString = json["octopus"]["in_app"]["payinfo"].string else {
                        delegate.onFinished(intent: intent, result: result, error: .dataFormatError)
                        return
                    }
              
                    delegate.onInterrupt(intent: intent)
                    let scheme = WonderPayment.paymentConfig.fromScheme
                    let urlString = "\(paymentString)&return=\(scheme)://octopus"
                    guard let url = URL(string: urlString) else {
                        delegate.onFinished(intent: intent, result: result, error: .dataFormatError)
                        return
                    }
                    
                    UIApplication.shared.open(url) { succeed in
                        if succeed {
                            WonderPayment.octopusCallback = { _ in
                                let orderNum = intent.orderNumber
                                delegate.onProcessing()
                                PaymentService.loopForResult(uuid: transaction.uuid, orderNum: orderNum) {
                                    result, error in
                                    delegate.onFinished(intent: intent, result: result, error: error)
                                }
                            }
                        } else {
                            delegate.onFinished(intent: intent, result: nil, error: .unsupportedError)
                        }
                    }
                } else {
                    delegate.onFinished(intent: intent, result: result, error: error)
                }
            }
        }
    }
    
}
