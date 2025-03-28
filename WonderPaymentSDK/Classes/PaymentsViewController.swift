//
//  PaymentsViewController.swift
//  PaymentSDK
//
//  Created by Levey on 2024/3/1.
//

import UIKit
import IQKeyboardManagerSwift
import QMUIKit

enum PaymentStatus {
    case normal,pending,error,success
}

enum SessionMode {
    //once: 一次会话完成所有操作
    //twice: 选择支付方式和支付拆分为两个会话
    case once, twice
}

class PaymentsViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let isDark = WonderPayment.uiConfig.background.qmui_colorIsDark
        if #available(iOS 13.0, *) {
            return isDark ? .lightContent : .darkContent
        } else {
            return isDark ? .lightContent : .default
        }
    }
    
    ///支付参数
    var intent: PaymentIntent? {
        didSet {
            guard let intent = intent else { return }
            let amountText = "\(CurrencySymbols.get(intent.currency))\(formatAmount(intent.amount))"
            mView.amountLabel.text = amountText
            if sessionMode == .once {
                let buttonText = "\("pay".i18n) \(amountText)"
                mView.methodView.cardConfirmButton.setTitle(buttonText, for: .normal)
                mView.bankCardView.confirmButton.setTitle(buttonText, for: .normal)
            }
        }
    }
    ///支付回调
    var paymentCallback: PaymentResultCallback?
    var selectCallback: SelectMethodCallback?
    ///会话模式
    var sessionMode: SessionMode = .once
    /// 显示风格
    var displayStyle: DisplayStyle = .oneClick
    /// 查看编辑模式
    var previewMode: Bool = false
    
    lazy var mView = PaymentsView(
        displayStyle: displayStyle,
        sessionMode: sessionMode,
        previewMode: previewMode,
        transactionType: intent?.transactionType ?? .sale
    )
    var paymentStatus: PaymentStatus = .normal {
        didSet {
            mView.setUIStatus(paymentStatus)
        }
    }
    
    /// 上次支付的PaymentIntent，重试时使用
    var lastPaymentIntent: PaymentIntent?
    
    /// 支付结果
    var paymentResult: PaymentResult?
    
    /// 卡列表
    var cards: [CreditCardInfo]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mView)
        mView.setUIStatus(paymentStatus)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        gestureRecognizer.cancelsTouchesInView = false
        UIApplication.shared.keyWindow?.addGestureRecognizer(gestureRecognizer)
        mView.titleBar.rightView.addTarget(self, action:#selector(close(_:)), for: .touchUpInside)
        mView.errorView.retryButton.addTarget(self, action:#selector(retry(_:)), for: .touchUpInside)
        mView.methodView.addCardButton.addTarget(self, action:#selector(showAddCard(_:)), for: .touchUpInside)
        mView.bankCardView.backButton.addTarget(self, action:#selector(hideAddCard(_:)), for: .touchUpInside)
        mView.bankCardView.confirmButton.addTarget(self, action: #selector(addCardConfirmed(_:)), for: .touchUpInside)
        loadData()
        
        mView.onMethodConfirm = {
            [unowned self] method in
            if previewMode {
                let previewController = MethodPreviewController(method: method, delegate: self)
                self.navigationController?.pushViewController(previewController, animated: true)
                return
            }
            if self.sessionMode == .twice {
                self.dismiss() {
                    self.selectCallback?(method)
                }
            } else {
                guard let intent = intent else { return }
                let paymentIntent = intent.copy()
                paymentIntent.paymentMethod = method
                paymentResult = nil
                pay(intent: paymentIntent, delegate: self)
            }
        }
    }
    
    private func loadData() {
        getBannerData()
        getPaymentMethodsData()
    }
    
    private func getPaymentMethodsData() {
        PaymentService.queryPaymentMethods() {
            [weak self] config, err in
            if let config = config {
                Cache.set(config, for: "paymentMethodConfig")
                self?.setPaymentMethods(config)
            }
            if let error = err {
                ErrorPage.show(error: error, onRetry: {
                    self?.getPaymentMethodsData()
                }, onExit: {
                    self?.dismiss()
                    self?.paymentCallback?(PaymentResult(status: .canceled))
                })
            }
        }
    }
    
    private func setPaymentMethods(_ config: PaymentMethodConfig) {
        let isPreAuth = intent?.transactionType == .preAuth
        let supportList = config.supportPaymentMethods
        var supportApplePay = false
        var supportCard = false
        var supportUnionPay = false
        var supportAlipay = false
        var supportWechat = false
        var supportOctopus = false
        var supportFps = false
        var supportPayMe = false
        for item in supportList {
            if (item == PaymentMethodType.applePay.rawValue) {
                supportApplePay = true
            } else if (item == PaymentMethodType.creditCard.rawValue) {
                if WonderPayment.paymentConfig.customerId.isEmpty {
                    supportCard = sessionMode == .once && previewMode != true
                } else {
                    supportCard = true
                }
            } else if (item == PaymentMethodType.unionPay.rawValue && !isPreAuth) {
                supportUnionPay = true
            } else if (item == PaymentMethodType.alipay.rawValue && !isPreAuth) {
                supportAlipay = true
            } else if (item == PaymentMethodType.wechat.rawValue && !isPreAuth) {
                supportWechat = true
            } else if (item == PaymentMethodType.octopus.rawValue && !isPreAuth) {
                supportOctopus = true
            } else if (item == PaymentMethodType.fps.rawValue && !isPreAuth) {
                supportFps = true
            } else if (item == PaymentMethodType.payme.rawValue && !isPreAuth) {
                supportPayMe = true
            }
        }
        
        if supportCard {
            queryCardList()
            mView.methodView.cardView.isHidden = false
        }
        let applePayConfigured = WonderPayment.paymentConfig.applePay != nil
        let wechatPayConfigured = WonderPayment.paymentConfig.wechat != nil
        let supportApplePayCards = config.supportApplePayCards
        mView.methodView.applePayButton.isHidden = !(supportApplePay && applePayConfigured && !supportApplePayCards.isEmpty)
        mView.methodView.applePayButton.method?.arguments = ["supportCards": Array(supportApplePayCards)]
        mView.methodView.unionPayButton.isHidden = !supportUnionPay
        mView.methodView.alipayButton.isHidden = !(supportAlipay && isAlipayInstalled)
        mView.methodView.alipayHKButton.isHidden = !(supportAlipay && isAlipayHKInstalled)
        mView.methodView.wechatPayButton.isHidden = !(supportWechat && wechatPayConfigured)
        mView.methodView.octopusButton.isHidden = !supportOctopus
        mView.methodView.fpsButton.isHidden = !supportFps
        mView.methodView.paymeButton.isHidden = !supportPayMe
        mView.placeholderLayout.isHidden = true
    }
    
    private func getBannerData()  {
        if let bannerData = DiskCache.shared.getFileContent("banner.data") {
            let dataJson = DynamicJson.from(bannerData)
            let items = AdItem.from(jsonArray: dataJson.array.compactMap({$0.value}) as? NSArray)
            self.mView.banner.setData(items)
        }
         
        GatewayService.getBannerData() {
            [weak self] data, error in
            if let data = data {
                self?.mView.banner.setData(data)
                let jsonArr = data.map { $0.toJson() }
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonArr, options: []),
                    let bannerData = String(data: jsonData, encoding: .utf8) {
                    DiskCache.shared.writeFile("banner.data", content: bannerData)
                }
            }
        }
    }
    
    private func queryCardList() {
        PaymentService.queryCardList {
            [weak self] cards, error in
            self?.cards = cards
            self?.mView.methodView.setCardItems(cards ?? [])
        }
    }
    
    private func resetUI() {
        mView.scrollView.qmui_scrollToTop()
        mView.showAddCard = false
        self.view.endEditing(true)
    }
    
    private func dismiss(completion: (() -> Void)? = nil) {
        self.presentingViewController?.dismiss(animated: true, completion: completion)
    }
    
    @objc func onTap(_ sender: UIView) {
        self.view.endEditing(true)
    }
    
    @objc func close(_ sender: UIButton) {
        if sessionMode == .twice || previewMode {
            self.dismiss()
        } else {
            if (paymentResult?.status != .completed) {
                Dialog.confirm(title: "closeSession".i18n, message: "sureToLeave".i18n, button1: "continuePayment".i18n, button2: "back".i18n, action2: {
                    [unowned self] controller in
                    controller.hideWith(animated: true)
                    self.dismiss()
                    paymentCallback?(paymentResult ?? PaymentResult(status: .canceled))
                })
            } else {
                self.dismiss()
                paymentCallback?(paymentResult ?? PaymentResult(status: .canceled))
            }
        }
    }
    
    @objc func showAddCard(_ sender: UIButton) {
        mView.showAddCard = true
    }
    
    @objc func hideAddCard(_ sender: UIButton) {
        mView.showAddCard = false
        self.view.endEditing(true)
    }
    
    ///重新支付
    @objc func retry(_ sender: UIButton) {
        if let intent = lastPaymentIntent {
            paymentResult = nil
            pay(intent: intent, delegate: self)
        }
    }
    
    /// 添加卡片确认
    @objc func addCardConfirmed(_ sender: UIButton) {
        if sessionMode == .twice || previewMode {
            let form = mView.bankCardView.form
            let args = form.toArguments()
            addCard(args)
        } else {
            //"card_reader_mode": "manual"
            let form = mView.bankCardView.form
            let args = form.toArguments()
            if form.save {
                bindCard(args) {
                    [weak self] cardInfo in
                    guard let cardInfo = cardInfo else {
                        return
                    }
                    self?.cardPay(["token": cardInfo.token])
                }
            } else {
                cardPay(args)
            }
        }
    }
    
    private func cardPay(_ args: [String: Any?]) {
        guard let intent = intent else { return }
        let paymentIntent = intent.copy()
        paymentIntent.paymentMethod = PaymentMethod(type: .creditCard, arguments: args as NSDictionary)
        paymentResult = nil
        pay(intent: paymentIntent, delegate: self)
    }
    
    private func addCard(_ args: [String: Any?]) {
        bindCard(args) {
            [weak self] cardInfo in
            guard let cardInfo = cardInfo else {
                return
            }
            Tips.show(image: "verified".svg, title: "cardVerified".i18n, subTitle: "canStartPaying".i18n) {
                [weak self] _ in
                self?.resetUI()
                self?.cards?.insert(cardInfo, at: 0)
                self?.mView.methodView.setCardItems(self?.cards ?? [])
            }
        }
    }
    
    
    private func bindCard(_ args: [String: Any?], completion: ((CreditCardInfo?) -> Void)? = nil) {
        Loading.show()
        PaymentService.bindCard(cardInfo: args as NSDictionary) {
            [weak self] cardInfo, error in
            Loading.dismiss()
            
            guard let cardInfo = cardInfo else {
                completion?(nil)
                Tips.show(style: .error, title: error?.code, subTitle: error?.message)
                return
            }
            
            self?.checkIfValid(cardInfo) { valid,error in
                if !valid {
                    completion?(nil)
                    Tips.show(style: .error, title: error?.code, subTitle: error?.message)
                    return
                }
                completion?(cardInfo)
            }
        }
    }
    
    private func checkIfValid(_ card: CreditCardInfo, callback: @escaping (Bool, ErrorMessage?) -> Void) {
        if card.state == "success" {
            callback(true, nil)
        } else if card.state == "pending" {
            if let _3dsUrl = card.verifyUrl {
                let browserController = BrowserViewController()
                browserController.modalPresentationStyle = .fullScreen
                browserController.url = _3dsUrl
                browserController.finishedCallback = {
                    [weak self] result in
                    guard let succeed = result as? Bool, succeed else {
                        callback(false, ErrorMessage._3dsVerificationError)
                        return
                    }
                    Loading.show()
                    self?.checkPaymentTokenIsValid(card) { valid, error in
                        Loading.dismiss()
                        callback(valid, error)
                    }
                }
                self.present(browserController, animated: true)
            } else {
                Loading.show()
                self.checkPaymentTokenIsValid(card) { valid, error in
                    Loading.dismiss()
                    callback(valid, error)
                }
            }
        } else {
            callback(false, ErrorMessage.bindCardError)
        }
    }
    
    private func checkPaymentTokenIsValid(
        _ card: CreditCardInfo,
        retryCount: Int = 60 ,
        callback: @escaping (Bool, ErrorMessage?) -> Void
    ) {
        guard let uuid = card.verifyUuid, let token = card.token else {
            callback(false, ErrorMessage.argumentsError)
            return
        }
        if retryCount < 1 {
            callback(false, ErrorMessage.bindCardError)
            return
        }
        PaymentService.checkPaymentTokenState(uuid: uuid, token: token) {
            [weak self] state, err in
            if state == "success" {
                callback(true, nil)
                return
            } else if state == "failed" {
                callback(false, ErrorMessage.bindCardError)
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let count = retryCount - 1
                self?.checkPaymentTokenIsValid(card, retryCount: count, callback: callback)
            }
        }
    }
    
    deinit {
        Cache.dispose()
    }
}

extension PaymentsViewController: PaymentDelegate {
    
    func onInterrupt(intent: PaymentIntent) {
        Loading.dismiss()
        paymentStatus = .pending
        resetUI()
        let nameAndIcon = getMethodNameAndIcon(intent.paymentMethod!)
        mView.pendingView.paymentItem.value = nameAndIcon.0
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = "MMM d, yyyy\nHH:mm:ss a"
        let dateTime = dateFormatter.string(from: date)
        mView.pendingView.initAtItem.value = dateTime
    }
    
    func onProcessing() {
        Loading.show(style: .fullScreen)
    }
    
    func onFinished(intent: PaymentIntent, result: PayResult?, error: ErrorMessage?) {
        resetUI()
        Loading.dismiss()
        lastPaymentIntent = intent
        if let error = error {
            paymentStatus = .error
            mView.errorView.errorMessage = error
            paymentResult = PaymentResult(status: .failed, code: error.code, message: error.message)
        }
        if let transaction = result?.transaction {
            if transaction.success {
                paymentStatus = .success
                mView.successfulView.setData(result!, intent: intent)
                paymentResult = PaymentResult(status: .completed)
                TransactionMonitor.monitorTransaction(transaction)
            } else {
                let paymentData = DynamicJson(value: transaction.paymentData)
                let code = paymentData["resp_code"].string
                let message = paymentData["resp_msg"].string
                paymentStatus = .error
                mView.errorView.errorMessage = ErrorMessage(code: code ?? "", message: message ?? "")
                paymentResult = PaymentResult(status: .failed, code: code, message: message)
            }
        }
        if !WonderPayment.uiConfig.showResult || (paymentResult?.status != .completed && !WonderPayment.uiConfig.paymentRetriesEnabled) {
            paymentCallback?(paymentResult!)
            self.dismiss()
        }
    }
    
    func onCanceled() {
        if !WonderPayment.uiConfig.paymentRetriesEnabled {
            paymentCallback?(PaymentResult(status: .canceled))
            self.dismiss()
        }
    }
}

extension PaymentsViewController : MethodPreviewDelegate {
    func tokenDeleted(token: String) {
        cards?.removeAll(where: {$0.token == token})
        mView.methodView.setCardItems(cards ?? [])
    }
}
