public enum PaymentMethodType: String {
    case creditCard = "credit_card",
         applePay = "apple_pay",
         unionPay = "unionpay_wallet",
         wechat = "wechat",
         alipayHK = "alipay_hk",
         alipay = "alipay",
         fps = "fps",
         octopus = "octopus"
}

public class PaymentMethod : JSONDecodable, JSONEncodable {
    public var type: PaymentMethodType
    public var arguments: NSDictionary?
    
    public init(type: PaymentMethodType, arguments: NSDictionary? = nil) {
        self.type = type
        self.arguments = arguments
    }
    
    public static func from(json: NSDictionary?) -> Self {
        return PaymentMethod(
            type: PaymentMethodType(rawValue: json?["type"] as? String ?? "") ?? .creditCard,
            arguments: json?["arguments"] as? NSDictionary
        ) as! Self
    }
    
    public func toJson() -> Dictionary<String, Any?> {
        return [
            "type": type.rawValue,
            "arguments": arguments,
        ]
    }
}
