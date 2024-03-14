
struct PaymentMethodConfig: JSONDecodable {
    
    var supportPaymentMethod: [String]?
    
    static func from(json: NSDictionary?) -> PaymentMethodConfig {
        let supportPaymentMethod = json?["support_payment_method"] as? [String]
        return PaymentMethodConfig(supportPaymentMethod: supportPaymentMethod)
    }
    
}
