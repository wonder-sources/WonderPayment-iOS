//
//  PaymentSDK.swift
//  PaymentSDK
//
//  Created by Levey on 2024/3/1.
//

import Foundation
import UIKit
import PassKit

class NavigationController: UINavigationController {
    //    override var childViewControllerForStatusBarStyle: UIViewController? {
    //        return visibleViewController
    //    }
}

public typealias PaymentResultCallback = (PaymentResult) -> Void
public typealias SelectMethodCallback = (PaymentMethod) -> Void
public typealias DefaultMethodCallback = (PaymentMethod?) -> Void
public typealias DataCallback = ([String: Any?]) -> Void
public typealias ApplePayCompletion = (PKPaymentAuthorizationResult) -> Void
public typealias AppyPayCallback = (String?, ApplePayCompletion?) -> Void
public typealias CompletionCallback = (Bool) -> Void

public class WonderPayment : NSObject {
    public static var uiConfig = UIConfig()
    public static var paymentConfig = PaymentConfig()
    static var unionPayCallback: DataCallback?
    static var alipayCallback: DataCallback?
    static var wechatPayCallback: DataCallback?
    static var applePayCallback: AppyPayCallback?
    static var octopusCallback: DataCallback?
    static var fpsCallback: DataCallback?
    static var paymeCallback: DataCallback?
    static var wechatPayDelegate = WechatPayDelegate()
    static var applePayDelegate = ApplePayDelegate()
    
    public static func initSDK(
        paymentConfig: PaymentConfig? = nil,
        uiConfig: UIConfig? = nil
    ){
        if let paymentConfig = paymentConfig {
            WonderPayment.paymentConfig = paymentConfig
        }
        if let uiConfig = uiConfig {
            WonderPayment.uiConfig = uiConfig
        }
        _ = CustomFonts.loadFonts
        registerApp()
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private static func appWillEnterForeground() {
        //print("App will enter foreground - SDK detected")
    }
    
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
        transactionType: TransactionType,
        callback: @escaping SelectMethodCallback
    ) {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        let paymentsViewController = PaymentsViewController()
        paymentsViewController.sessionMode = .twice
        paymentsViewController.displayStyle = uiConfig.displayStyle
        paymentsViewController.intent = PaymentIntent(amount: 0, currency: "", orderNumber: "", transactionType: transactionType)
        paymentsViewController.selectCallback = callback
        paymentsViewController.modalPresentationStyle = .fullScreen
        rootViewController?.present(paymentsViewController, animated: true)
    }
    
    /// 查看管理支付方式
    public static func preview() {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        let paymentsViewController = PaymentsViewController()
        paymentsViewController.previewMode = true
        let navController = NavigationController(rootViewController: paymentsViewController)
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .fullScreen
        rootViewController?.present(navController, animated: true)
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
        } else if (url.host == "octopus") {
            octopusCallback?([:])
            octopusCallback = nil
        } else if (url.host == "fps") {
            fpsCallback?([:])
            fpsCallback = nil
        } else if (url.host == "payme") {
            paymeCallback?([:])
            paymeCallback = nil
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
    
    /// handleOpenUniversalLink
    public static func handleOpenUniversalLink(userActivity: NSUserActivity) -> Bool {
        return WXApi.handleOpenUniversalLink(userActivity, delegate: WonderPayment.wechatPayDelegate)
    }
    
    /// 注册SDK
    public static func registerApp() {
        if let appId = paymentConfig.wechat?.appId,
           let universalLink = paymentConfig.wechat?.universalLink {
            WXApi.registerApp(appId, universalLink: universalLink)
        }
    }
    
    /// 获取默认支付方式
    public static func getDefaultPaymentMethod(callback: @escaping DefaultMethodCallback) {
        PaymentService.getCustomerProfile { data, error in
            guard let data = data else {
                callback(nil)
                return
            }
            guard let method = data["customer"]["default_payment_method"].string else {
                callback(nil)
                return
            }
            guard let type = PaymentMethodType(rawValue: method) else {
                callback(nil)
                return
            }
            let paymentMethod = PaymentMethod(type: type)
            if type == .creditCard {
                let args = data["customer"]["default_payment_token"].value
                let cardInfo = CreditCardInfo.from(json: args as? NSDictionary)
                paymentMethod.arguments = cardInfo.toPaymentArguments()
            }
            callback(paymentMethod)
        }
    }
    
    /// 设置默认支付方式
    public static func setDefaultPaymentMethod(
        _ paymentMethod: PaymentMethod,
        callback: @escaping CompletionCallback
    ) {
        let args: NSMutableDictionary = ["default_payment_method": paymentMethod.type.rawValue]
        if paymentMethod.type == .creditCard, let token = paymentMethod.arguments?["token"] as? String {
            args["default_payment_token"] = token
        }
        PaymentService.setCustomerProfile(args) { result, error in
            callback(result == true)
        }
    }
    
    public static func getPaymentResult(sessionId: String, callback: @escaping PaymentResultCallback) {
        PaymentService.getPayResult(sessionId: sessionId) { status, error in
            if status == .completed {
                callback(PaymentResult(status: .completed))
            } else {
                callback(PaymentResult(status: .pending))
            }
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
