

protocol PaymentDelegate {
    func onProcessing()
    ///中断，等待第三方回调
    func onInterrupt(intent: PaymentIntent)
    func onFinished(intent: PaymentIntent, result: PayResult?, error: ErrorMessage?)
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
        hander = UPPaymentHandler()
    case .wechat:
        hander = WechatPaymentHandler()
    case .alipay, .alipayHK:
        hander = AlipayPaymentHandler()
    default:()
    }
    hander?.pay(intent: intent, delegate: delegate)
}
