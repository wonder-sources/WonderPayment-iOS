//
//  PaymentSDK.swift
//  PaymentSDK
//
//  Created by Levey on 2024/3/1.
//

import Foundation
import UIKit

public typealias PaymentResultCallback = (PaymentResult) -> Void
public typealias DataCallback = ([String: Any?]) -> Void

public class WonderPayment : NSObject {
    public static var uiConfig = UIConfig()
    public static var paymentConfig = PaymentConfig()
    static var unionPayCallback: DataCallback?
    static var alipayCallback: DataCallback?
    static var wxDelegate = WxDelegate()
    
    /// UI支付
    public static func present(
        intent: PaymentIntent,
        callback: @escaping PaymentResultCallback
    ) {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        let paymentsViewController = PaymentsViewController()
        paymentsViewController.selectMode = false
        paymentsViewController.intent = intent
        paymentsViewController.callback = callback
        paymentsViewController.modalPresentationStyle = .fullScreen
        rootViewController?.present(paymentsViewController, animated: true)
    }
    
    /// 无UI支付
    public static func pay(intent: PaymentIntent, callback: PaymentResultCallback) {
        
    }
    
    /// 三方支付回调处理
    public static func handleOpenURL(url: URL) -> Bool {
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url) { data in
                let resultStatus = data?["resultStatus"]
                let memo = data?["memo"]
                let callbackData: [String: Any?] = ["resultStatus": resultStatus, "memo": memo]
                alipayCallback?(callbackData)
            }
        }
        UPPaymentControl.default().handlePaymentResult(url) { code, data in
            //code : success, fail, cancel
            let callbackData: [String: Any?] = ["code": code, "data": data]
            unionPayCallback?(callbackData)
        }
        WXApi.handleOpen(url, delegate: wxDelegate)
        return true
    }
    
    /// 注册SDK
    public static func registerApp() {
        WXApi.registerApp("", universalLink: "")
    }
}
