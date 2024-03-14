

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
    case .creditCard:
        hander = CardPaymentHandler()
    case .unionPay:
        intent.paymentMethod?.arguments = [
            "in_app":[:]
        ]
        hander = UPPaymentHandler()
    case .wechat:
        let appId = WonderPayment.paymentConfig.wechat.appId
        intent.paymentMethod?.arguments = [
            "in_app": [ "app_id": appId]
        ]
        hander = WechatPaymentHandler()
    case .alipay:
        intent.paymentMethod?.arguments = [
            "in_app": [
                "app_env": "ios",
                "payment_inst": "ALIPAYCN",
            ]
        ]
        hander = AlipayPaymentHandler()
    case .alipayHK:
        intent.paymentMethod?.arguments = [
            "in_app": [
                "app_env": "ios",
                "payment_inst": "ALIPAYHK",
            ]
        ]
        hander = AlipayPaymentHandler()
    default:()
    }
    hander?.pay(intent: intent, delegate: delegate)
}
