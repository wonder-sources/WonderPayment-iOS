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

class PaymentsViewController: UIViewController {
    
    ///支付参数
    var intent: PaymentIntent! {
        didSet {
            let amountText = "\(CurrencySymbols.get(intent.currency))\(formatAmount(intent.amount))"
            mView.amountLabel.text = amountText
            if !selectMode {
                let buttonText = "\("pay".i18n) \(amountText)"
                mView.methodView.cardConfirmButton.setTitle(buttonText, for: .normal)
                mView.bankCardView.confirmButton.setTitle(buttonText, for: .normal)
            }
        }
    }
    ///支付回调
    var paymentCallback: PaymentResultCallback?
    var selectCallback: SelectMethodCallback?
    ///选择模式
    var selectMode = false
    
    lazy var mView = PaymentsView(selectMode: selectMode)
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
            if self.selectMode {
                self.selectCallback?(method)
                self.dismiss()
            } else {
                let paymentIntent = self.intent.copy()
                paymentIntent.paymentMethod = method
                pay(intent: paymentIntent, delegate: self)
            }
        }
    }
    
    private func loadData() {
        let businessId = WonderPayment.paymentConfig.businessId
        PaymentService.queryPaymentMethods(businessId: businessId) { 
            [weak self] config, err in
            let supportList = config?.supportPaymentMethod ?? []
            var supportCard = false
            var supportUnionPay = false
            var supportAlipay = false
            var supportWechat = false
            for item in supportList {
                if (CardMap.names.keys.contains(item)) {
                    supportCard = true
                } else if (item == "unionpay_wallet") {
                    supportUnionPay = true
                } else if (item == "alipay") {
                    supportAlipay = true
                } else if (item == "wechat") {
                    supportWechat = true
                }
            }
            
            if supportCard {
                self?.queryCardList()
                self?.mView.methodView.cardView.isHidden = false
            }
            let applePayConfigured = WonderPayment.paymentConfig.applePay != nil
            let wechatPayConfigured = WonderPayment.paymentConfig.wechat != nil
            self?.mView.methodView.applePayButton.isHidden = !applePayConfigured
            self?.mView.methodView.unionPayButton.isHidden = !supportUnionPay
            self?.mView.methodView.alipayButton.isHidden = !supportAlipay
            self?.mView.methodView.alipayHKButton.isHidden = !supportAlipay
            self?.mView.methodView.wechatPayButton.isHidden = !(supportWechat && wechatPayConfigured)
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
    
    private func dismiss() {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc func onTap(_ sender: UIView) {
        self.view.endEditing(true)
    }
    
    @objc func close(_ sender: UIButton) {
        if selectMode {
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
            pay(intent: intent, delegate: self)
        }
    }
    
    /// 添加卡片确认
    @objc func addCardConfirmed(_ sender: UIButton) {
        if selectMode {
            let form = mView.bankCardView.form
            let expDate = form.expDate
            let arr = expDate.split(separator: "/")
            let expYear = arr.first
            let expMonth = arr.last
            let args: [String : Any?] = [
                "exp_date": expDate.replace("/", with: ""),
                "exp_year": expYear,
                "exp_month": expMonth,
                "number": form.number,
                "cvv": form.cvv,
                "holder_name": "\(form.firstName) \(form.lastName)",
                "default": true,
                "billing_address": [
                    "first_name": form.firstName,
                    "last_name": form.lastName,
                    "phone_number": form.phone,
                ],
            ]
            addCard(args)
        } else {
            let form = mView.bankCardView.form
            let expDate = form.expDate
            let arr = expDate.split(separator: "/")
            let expYear = arr.first
            let expMonth = arr.last
            let args: [String : Any?] = [
                "exp_date": expDate.replace("/", with: ""),
                "exp_year": expYear,
                "exp_month": expMonth,
                "number": form.number,
                "cvv": form.cvv,
                "holder_name": "\(form.firstName) \(form.lastName)",
                "card_reader_mode": "manual",
                "billing_address": [
                    "first_name": form.firstName,
                    "last_name": form.lastName,
                    "phone_number": form.phone,
                ],
                "is_auto_save": form.save,
            ]
            cardPay(args)
        }
    }
    
    private func cardPay(_ args: [String: Any?]) {
        let paymentIntent = intent.copy()
        paymentIntent.paymentMethod = PaymentMethod(type: .creditCard, arguments: args)
        pay(intent: paymentIntent, delegate: self)
    }
    
    private func addCard(_ args: [String: Any?]) {
        Loading.show()
        PaymentService.bindCard(cardInfo: args) { cardInfo, error in
            Loading.dismiss()
            if let error = error {
                Tips.show(style: .error, title: error.code, subTitle: error.message)
                return
            }
            
            if let cardInfo = cardInfo {
                Tips.show(image: "verified".svg, title: "cardVerified".i18n, subTitle: "canStartPaying".i18n) {
                    [weak self] _ in
                    self?.resetUI()
                    self?.cards?.insert(cardInfo, at: 0)
                    self?.mView.methodView.setCardItems(self?.cards ?? [])
                }
            }
        }
    }
    
}

extension PaymentsViewController: PaymentDelegate {
    
    func onInterrupt(intent: PaymentIntent) {
        Loading.dismiss()
        paymentStatus = .pending
        resetUI()
        let name: String
        switch(intent.paymentMethod?.type) {
        case .unionPay:
            name = "unionPay".i18n
        case.wechat:
            name = "wechatPay".i18n
        case .alipay:
            name = "alipay".i18n
        case .alipayHK:
            name = "alipayHK".i18n
        default:
            name = ""
            
        }
        mView.pendingView.paymentItem.value = name
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = "MMM d, yyyy\nh:mm:ss a"
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
        if let result = result,let success = result.success, success {
            paymentResult = PaymentResult(status: .completed)
            paymentCallback?(paymentResult!)
            self.dismiss()
        }
    }
    
    func onCanceled() {
        
    }
}
