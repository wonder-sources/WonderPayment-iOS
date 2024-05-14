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
    
    func pay(intent: PaymentIntent, delegate: PaymentDelegate) {
        let isInstalled = UIApplication.shared.canOpenURL(URL(string: "octopus://payment")!)
        if !isInstalled {
            delegate.onFinished(intent: intent, result: nil, error: .unsupportedError)
            return
        }
        delegate.onProcessing()
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
                UIApplication.shared.open(url)
                WonderPayment.octopusCallback = { _ in
                    let orderNum = intent.orderNumber
                    delegate.onProcessing()
                    PaymentService.loopForResult(uuid: transaction.uuid, orderNum: orderNum) {
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
