

protocol PaymentDelegate {
    func onProcessing()
    ///中断，等待第三方回调
    func onInterrupt(intent: PaymentIntent)
    func onFinished(intent: PaymentIntent, result: PayResult?, error: ErrorMessage?)
    func onCanceled()
}

protocol PaymentHander {
    func pay(intent: PaymentIntent, delegate: PaymentDelegate)
}

func pay(intent: PaymentIntent, delegate: PaymentDelegate) {
    var hander: PaymentHander?
    switch(intent.paymentMethod?.type) {
    case .applePay:
        hander = ApplePayPaymentHandler()
    case .creditCard:
        hander = CardPaymentHandler()
        let cardArgs = intent.paymentMethod?.arguments
        var modeArgs: NSDictionary?
        if (intent.transactionType == .preAuth) {
            modeArgs = ["consume_mode": "pre_authorize"]
        }
        if let token = cardArgs?["token"] as? String {
            intent.paymentMethod?.arguments = [
                "payment_token": [
                    "amount": "\(intent.amount)",
                    "token": token
                ].merge(modeArgs)
            ]
        } else {
            intent.paymentMethod?.arguments = [
                "credit_card": [
                    "amount": "\(intent.amount)",
                    "3ds": PaymentService._3dsConfig
                ].merge(cardArgs).merge(modeArgs)
            ]
        }
        
    case .unionPay:
        intent.paymentMethod?.arguments = [
            "unionpay_wallet": [
                "amount": "\(intent.amount)",
                "in_app":[:],
            ]
        ]
        hander = UPPaymentHandler()
    case .wechat:
        let appId = WonderPayment.paymentConfig.wechat?.appId
        intent.paymentMethod?.arguments = [
            "wechatpay": [
                "amount": "\(intent.amount)",
                "in_app": ["app_id": appId]
            ]
        ]
        hander = WechatPaymentHandler()
    case .alipay:
        intent.paymentMethod?.arguments = [
            "alipay": [
                "amount": "\(intent.amount)",
                "in_app": [
                    "app_env": "ios",
                    "payment_inst": "ALIPAYCN",
                ]
            ]
        ]
        hander = AlipayPaymentHandler()
    case .alipayHK:
        intent.paymentMethod?.arguments = [
            "alipay": [
                "amount": "\(intent.amount)",
                "in_app": [
                    "app_env": "ios",
                    "payment_inst": "ALIPAYHK",
                ]
            ]
        ]
        hander = AlipayPaymentHandler()
    case .octopus:
        intent.paymentMethod?.arguments = [
            "octopus": [
                "amount": "\(intent.amount)",
                "in_app": [:]
            ]
        ]
        hander = OctopusPaymentHandler()
    default:()
    }
    hander?.pay(intent: intent, delegate: delegate)
}
