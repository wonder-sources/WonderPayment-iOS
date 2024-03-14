public enum PaymentMethodType: String {
    case creditCard = "credit_cards",
         applePay = "apple_pay",
         unionPay = "unionpay_wallet",
         wechat = "wechatpay",
         alipayHK = "alipay_hk",
         alipay = "alipay",
         fps = "fps",
         octopus = "octopus"
}

public class PaymentMethod {
    public var type: PaymentMethodType
    public var arguments: Any?
    
    public init(type: PaymentMethodType, arguments: Any? = nil) {
        self.type = type
        self.arguments = arguments
    }
}
