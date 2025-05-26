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
public typealias VoidCallback = () -> Void
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
    static var willEnterForegroundCallback: VoidCallback?
    
    public static let sdkVersion = "0.8.0"
    
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
        ConfigUtil.getConfigData(useCache: false) { _, _ in }
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private static func appWillEnterForeground() {
        willEnterForegroundCallback?()
    }
    
    /// UI支付
    public static func present(
        intent: PaymentIntent,
        callback: @escaping PaymentResultCallback
    ) {
        Loading.show()
        PaymentService.getOrderDetail(orderNum: intent.orderNumber).then { data in
            Loading.dismiss().map { _ in data }
        }.then { data in
            let preAuthOnly = data["is_only_pre_auth"].bool ?? false
            let paymentIntent = intent.copy()
            paymentIntent.isOnlyPreAuth = preAuthOnly
            let paymentsViewController = PaymentsViewController()
            paymentsViewController.sessionMode = .once
            paymentsViewController.displayStyle = uiConfig.displayStyle
            paymentsViewController.intent = paymentIntent
            paymentsViewController.paymentCallback = callback
            paymentsViewController.modalPresentationStyle = .fullScreen
            topViewController?.present(paymentsViewController, animated: true)
        }.catch { err in
            Loading.dismiss()
            let error = err as? ErrorMessage ?? ErrorMessage.unknownError
            ErrorPage.show(error: error, onRetry: {
                present(intent: intent, callback: callback)
            }, onExit: {
                callback(PaymentResult(status: .canceled))
            })
        }
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
        callback: @escaping SelectMethodCallback
    ) {
        let paymentsViewController = PaymentsViewController()
        paymentsViewController.sessionMode = .twice
        paymentsViewController.displayStyle = uiConfig.displayStyle
        paymentsViewController.selectCallback = callback
        paymentsViewController.modalPresentationStyle = .fullScreen
        topViewController?.present(paymentsViewController, animated: true)
    }
    
    /// 查看管理支付方式
    public static func preview() {
        let paymentsViewController = PaymentsViewController()
        paymentsViewController.previewMode = true
        let navController = NavigationController(rootViewController: paymentsViewController)
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .fullScreen
        topViewController?.present(navController, animated: true)
    }
    
    /// 三方支付回调处理
    public static func handleOpenURL(url: URL) -> Bool {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url) { data in
                let resultStatus = data?["resultStatus"]
                let memo = data?["memo"]
                let callbackData: [String: Any?] = ["resultStatus": resultStatus, "memo": memo]
                alipayCallback?(callbackData)
                alipayCallback = nil
            }
        } else if queryItems?.first(where: { $0.name == "auth_site" })?.value == "ALIPAY_HK" {
            var callbackData: [String: Any?] = [:]
            queryItems?.forEach({ item in
                callbackData[item.name] = item.value
            })
            alipayCallback?(callbackData)
            alipayCallback = nil
        } else if (url.host == "octopus") {
            octopusCallback?([:])
            octopusCallback = nil
        } else if (url.host == "fps") {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            let isSuccessfulValue = components?.queryItems?.first(where: { $0.name == "is_successful"})?.value
            fpsCallback?(["is_successful": isSuccessfulValue])
            fpsCallback = nil
        } else if (url.host == "payme") {
            var code = 0
            if url.path == "/fail" {
                code = -1
            }
            paymeCallback?(["code": code])
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
            if type == .creditCard, let args = data["customer"]["default_payment_token"].value {
                let cardInfo = CreditCardInfo.from(json: args as? NSDictionary)
                paymentMethod.arguments = cardInfo.toPaymentArguments()
            }
            
            let getPaymentMethodConfig: (@escaping(PaymentMethodConfig?) -> Void) -> Void = { result in
                if let config: PaymentMethodConfig = Cache.get(for: "paymentMethodConfig") {
                    result(config)
                } else {
                    PaymentService.queryPaymentMethods { config, error in
                        result(config)
                    }
                }
            }
            
            getPaymentMethodConfig { config in
                guard let config = config else {
                    callback(nil)
                    return
                }
                let intent: PaymentIntent? = Cache.get(for: "intent")
                let isOnlyPreAuth = intent?.isOnlyPreAuth ?? false
                let transactionType: TransactionType = isOnlyPreAuth ? .preAuth : .sale
                let isSupport = config.isSupport(method: type.rawValue, transactionType: transactionType)
                guard isSupport else {
                    callback(nil)
                    return
                }
                
                let entryTypes = config.getEntryTypes(method: paymentMethod.type.rawValue)
                paymentMethod.arguments.ensureAndAppend(contentsOf: [
                    "entryTypes": entryTypes
                ])
                if type == .applePay {
                    let supportCards = Array(config.getSupportApplePayCards(transactionType: transactionType))
                    paymentMethod.arguments.ensureAndAppend(contentsOf: [
                        "supportCards": supportCards
                    ])
                }
                callback(paymentMethod)
            }
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
    
    /// 获取支付结果
    public static func getPaymentResult(sessionId: String, callback: @escaping PaymentResultCallback) {
        PaymentService.getPayResult(sessionId: sessionId) { status, error in
            if status == .completed {
                callback(PaymentResult(status: .completed))
            } else {
                callback(PaymentResult(status: .pending))
            }
        }
    }
    
    /// 添加卡片
    public static func addCard(
        _ args: NSDictionary,
        showLoading: Bool = false,
        showTips: Bool = false,
        completion: ((NSDictionary?, NSDictionary?) -> Void)? = nil)
    {
        guard let cardArgs = args as? [String: Any] else {
            completion?(nil, ErrorMessage.argumentsError.toJson() as NSDictionary)
            return
        }
        CardUtil.bindCard(cardArgs, showLoading: showLoading, showTips: showTips) { card, error in
            if let card {
                completion?(card.toPaymentArguments(), nil)
            } else {
                completion?(nil, error?.toJson() as? NSDictionary)
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
