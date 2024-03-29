//
//  PaymentSDK.swift
//  PaymentSDK
//
//  Created by Levey on 2024/3/1.
//

import Foundation
import UIKit
import PassKit

public typealias PaymentResultCallback = (PaymentResult) -> Void
public typealias SelectMethodCallback = (PaymentMethod) -> Void
public typealias DataCallback = ([String: Any?]) -> Void
public typealias ApplePayCompletion = (PKPaymentAuthorizationResult) -> Void
public typealias AppyPayCallback = (String?, ApplePayCompletion?) -> Void

public class WonderPayment : NSObject {
    public static var uiConfig = UIConfig()
    public static var paymentConfig = PaymentConfig()
    static var unionPayCallback: DataCallback?
    static var alipayCallback: DataCallback?
    static var wechatPayCallback: DataCallback?
    static var applePayCallback: AppyPayCallback?
    static var wechatPayDelegate = WechatPayDelegate()
    static var applePayDelegate = ApplePayDelegate()
    
    /// UI支付
    public static func present(
        intent: PaymentIntent,
        callback: @escaping PaymentResultCallback
    ) {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        let paymentsViewController = PaymentsViewController()
        paymentsViewController.sessionMode = .once
        paymentsViewController.displayStyle = uiConfig.displayStyle
        paymentsViewController.intent = intent
        paymentsViewController.paymentCallback = callback
        paymentsViewController.modalPresentationStyle = .fullScreen
        rootViewController?.present(paymentsViewController, animated: true)
    }
    
    /// 无UI支付
    public static func pay(
        intent: PaymentIntent,
        callback: @escaping PaymentResultCallback
    ) {
        let delegate = DefaultPaymentDelegate(callback: callback)
        WonderPaymentSDK.pay(intent: intent, delegate: delegate)
    }
    
    /// 选择支付方式
    public static func select(
        intent: PaymentIntent, 
        callback: @escaping SelectMethodCallback
    ) {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        let paymentsViewController = PaymentsViewController()
        paymentsViewController.sessionMode = .twice
        paymentsViewController.displayStyle = uiConfig.displayStyle
        paymentsViewController.intent = intent
        paymentsViewController.selectCallback = callback
        paymentsViewController.modalPresentationStyle = .fullScreen
        rootViewController?.present(paymentsViewController, animated: true)
    }
    
    /// 三方支付回调处理
    public static func handleOpenURL(url: URL) -> Bool {
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url) { data in
                let resultStatus = data?["resultStatus"]
                let memo = data?["memo"]
                let callbackData: [String: Any?] = ["resultStatus": resultStatus, "memo": memo]
                alipayCallback?(callbackData)
                alipayCallback = nil
            }
        }
        UPPaymentControl.default().handlePaymentResult(url) { code, data in
            //code : success, fail, cancel
            let callbackData: [String: Any?] = ["code": code, "data": data]
            unionPayCallback?(callbackData)
            unionPayCallback = nil
        }
        WXApi.handleOpen(url, delegate: wechatPayDelegate)
        return true
    }
    
    /// 注册SDK
    public static func registerApp() {
        if let appId = paymentConfig.wechat?.appId,
           let universalLink = paymentConfig.wechat?.universalLink {
            WXApi.registerApp(appId, universalLink: universalLink)
        }
    }
}

class WechatPayDelegate: NSObject, WXApiDelegate {
    func onResp(_ resp: BaseResp) {
        if let resp = resp as? PayResp {
            let callbackData: [String: Any?] = ["code": resp.errCode, "message": resp.errStr]
            WonderPayment.wechatPayCallback?(callbackData)
            WonderPayment.wechatPayCallback = nil
        }
    }
}

class ApplePayDelegate: NSObject, PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true)
        WonderPayment.applePayCallback?(nil, nil)
        WonderPayment.applePayCallback = nil
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let tokenData = payment.token.paymentData
        let base64 = tokenData.base64EncodedString()
        WonderPayment.applePayCallback?(base64, completion)
        WonderPayment.applePayCallback = nil
    }
}
