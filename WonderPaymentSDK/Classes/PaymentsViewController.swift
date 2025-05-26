//
//  PaymentsViewController.swift
//  PaymentSDK
//
//  Created by Levey on 2024/3/1.
//

import UIKit
import IQKeyboardManagerSwift

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
        let isDark = WonderPayment.uiConfig.background.isDark
        if #available(iOS 13.0, *) {
            return isDark ? .lightContent : .darkContent
        } else {
            return isDark ? .lightContent : .default
        }
    }
    
    ///支付参数
    var intent: PaymentIntent? {
        didSet {
            Cache.set(intent, for: "intent")
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
    
    ///交易类型
    var transactionType: TransactionType {
        let isOnlyPreAuth = intent?.isOnlyPreAuth ?? false
        return isOnlyPreAuth ? .preAuth : .sale
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
        transactionType: (intent?.isOnlyPreAuth ?? false) ? .preAuth : .sale
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
        keyWindow?.addGestureRecognizer(gestureRecognizer)
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
        getPaymentConfigData()
    }
    
    private func getPaymentConfigData() {
        ConfigUtil.getConfigData().then { data in
            let json = DynamicJson(value: data)
            let paymentRetriesEnabled = json["settings"]["payment_retries_enabled"].bool ?? true
            WonderPayment.uiConfig.paymentRetriesEnabled = paymentRetriesEnabled
            return PaymentService.queryPaymentMethods()
        }.then { config in
            Cache.set(config, for: "paymentMethodConfig")
            let creditCard = PaymentMethodType.creditCard.rawValue
            let hasCustomerId = !WonderPayment.paymentConfig.customerId.isEmpty
            let supportCard = hasCustomerId && config.isSupport(method: creditCard, transactionType: self.transactionType)
            return Future<PaymentMethodConfig> { resolve, reject in
                if supportCard {
                    self.queryCardList {
                        resolve(config)
                    }
                } else {
                    resolve(config)
                }
            }
        }.then { config in
            WonderPayment.getDefaultPaymentMethod { defaultMethod in
                self.setPaymentMethods(config, defaultMethod: defaultMethod)
            }
        }.catch { err in
            if let error = err as? ErrorMessage {
                ErrorPage.show(error: error, onRetry: {
                    self.getPaymentConfigData()
                }, onExit: {
                    self.dismiss()
                    self.paymentCallback?(PaymentResult(status: .canceled))
                })
            }
        }
    }
    
    private func setPaymentMethods(_ config: PaymentMethodConfig, defaultMethod: PaymentMethod?) {
        let paymentButtons: [MethodItemView] = [
            mView.methodView.applePayButton,
            mView.methodView.unionPayButton,
            mView.methodView.alipayButton,
            mView.methodView.alipayHKButton,
            mView.methodView.wechatPayButton,
            mView.methodView.octopusButton,
            mView.methodView.fpsButton,
            mView.methodView.paymeButton,
        ]
        
        for paymentButton in paymentButtons {
            let methodType = paymentButton.method?.type
            let typeValue = methodType?.rawValue ?? ""
            paymentButton.isHidden = !config.isSupport(method: typeValue, transactionType: transactionType)
            if methodType == .applePay {
                let supportApplePayCards = config.getSupportApplePayCards(transactionType: transactionType)
                paymentButton.method?.arguments.ensureAndAppend(contentsOf: ["supportCards": Array(supportApplePayCards)])
            }
            let entryTypes = config.getEntryTypes(method: typeValue)
            paymentButton.method?.arguments.ensureAndAppend(contentsOf: [
                "entryTypes": entryTypes
            ])
        }
        
        let creditCard = PaymentMethodType.creditCard.rawValue
        let hasCustomerId = !WonderPayment.paymentConfig.customerId.isEmpty
        let supportCard = hasCustomerId && config.isSupport(method: creditCard, transactionType: transactionType)
        mView.methodView.cardView.isHidden = !supportCard
        mView.placeholderLayout.isHidden = true
        
        if let defaultMethod {
            DispatchQueue.main.async {
                self.mView.setSelectedMethod(defaultMethod)
            }
        }
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
    
    private func queryCardList(completed: (() -> Void)? = nil) {
        PaymentService.queryCardList {
            [weak self] cards, error in
            self?.cards = cards
            self?.mView.methodView.setCardItems(cards ?? [])
            completed?()
        }
    }
    
    private func resetUI() {
        mView.scrollView.scrollToTop(animated: false)
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
                addCard(args, showTips: false) {
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
    
    private func addCard(_ args: [String: Any?], showTips:Bool = true, completion: ((CreditCardInfo?) -> Void)? = nil) {
        CardUtil.bindCard(args.compactMapValues{$0}) {
            [weak self] card, _ in
            guard let card else {
                return
            }
            let setUI = {
                self?.resetUI()
                self?.cards?.insert(card, at: 0)
                self?.mView.methodView.setCardItems(self?.cards ?? [])
                let method = PaymentMethod(type: .creditCard, arguments: card.toPaymentArguments())
                self?.mView.setSelectedMethod(method)
            }
            if showTips {
                Tips.show(image: "verified".svg, title: "cardVerified".i18n, subTitle: "canStartPaying".i18n) { _ in
                    setUI()
                    completion?(card)
                }
            } else {
                setUI()
                completion?(card)
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
        dateFormatter.locale = Foundation.Locale(identifier: "en_GB")
        dateFormatter.dateFormat = "MMM d, yyyy\nHH:mm:ss"
        let dateTime = dateFormatter.string(from: date)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "a"
        dateFormatter2.amSymbol = "AM"
        dateFormatter2.pmSymbol = "PM"
        let ampmPart = dateFormatter2.string(from: date)
        mView.pendingView.initAtItem.value = "\(dateTime) \(ampmPart)"
    }
    
    func onProcessing() {
        Loading.show(animated: false, style: .fullScreen)
    }
    
    func onFinished(intent: PaymentIntent, result: PayResult?, error: ErrorMessage?) {
        Loading.dismiss()
        resetUI()
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
