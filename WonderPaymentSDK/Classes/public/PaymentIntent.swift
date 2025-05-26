public class PaymentIntent : JSONDecodable, JSONEncodable {
    public var amount: Double
    public var currency: String
    public var orderNumber: String
    public var paymentMethod: PaymentMethod?
    // 预授权优先(客户端配置)
    public var preAuthModeForSales: Bool
    // 仅使用预授权(网关配置)
    var isOnlyPreAuth: Bool = false
    public var lineItems: [LineItem]?
    public var extra: Extra?
    
    public init(
        amount: Double,
        currency: String,
        orderNumber: String,
        paymentMethod: PaymentMethod? = nil,
        preAuthModeForSales: Bool = false,
        lineItems: [LineItem]? = nil,
        extra: Extra? = nil
    ) {
        self.amount = amount
        self.currency = currency
        self.orderNumber = orderNumber
        self.paymentMethod = paymentMethod
        self.preAuthModeForSales = preAuthModeForSales
        self.lineItems = lineItems
        self.extra = extra
    }
    
    public func copy() -> PaymentIntent {
        let intent = PaymentIntent(
            amount: self.amount,
            currency: self.currency,
            orderNumber: self.orderNumber,
            paymentMethod: self.paymentMethod?.copy(),
            preAuthModeForSales: self.preAuthModeForSales,
            lineItems: self.lineItems?.map({$0.copy()}),
            extra: self.extra?.copy()
        )
        intent.isOnlyPreAuth = self.isOnlyPreAuth
        return intent
    }
    
    public static func from(json: NSDictionary?) -> Self {
        var paymentMethod: PaymentMethod?
        if let methodJson = json?["paymentMethod"] as? NSDictionary {
            paymentMethod = PaymentMethod.from(json: methodJson)
        }
        return PaymentIntent(
            amount: json?["amount"] as? Double ?? 0.0,
            currency: json?["currency"] as? String ?? "HKD",
            orderNumber: json?["orderNumber"] as? String ?? "",
            paymentMethod: paymentMethod,
            preAuthModeForSales: json?["preAuthModeForSales"] as? Bool ?? false,
            lineItems: LineItem.from(jsonArray: json?["lineItems"] as? NSArray),
            extra: Extra.from(json: json?["extra"] as? NSDictionary)
        ) as! Self
    }
    
    func toJson() -> Dictionary<String, Any?> {
        return [
            "amount": amount,
            "currency": currency,
            "orderNumber": orderNumber,
            "paymentMethod": paymentMethod?.toJson(),
            "preAuthModeForSales": preAuthModeForSales,
            "lineItems": lineItems?.map({$0.toJson()}),
            "extra": extra?.toJson()
        ]
    }
}
