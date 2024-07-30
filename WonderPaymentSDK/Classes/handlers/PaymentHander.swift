

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
    case .unionPay:
        hander = UPPaymentHandler()
    case .wechat:
        hander = WechatPaymentHandler()
    case .alipay:
        hander = AlipayPaymentHandler()
    case .alipayHK:
        hander = AlipayPaymentHandler()
    case .octopus:
        hander = OctopusPaymentHandler()
    case .fps:
        hander = FPSPaymentHandler()
    default:()
    }
    hander?.pay(intent: intent, delegate: delegate)
}
