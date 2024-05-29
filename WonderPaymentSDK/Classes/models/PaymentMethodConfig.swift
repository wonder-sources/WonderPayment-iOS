
struct PaymentMethodConfig: JSONDecodable {
    
    var supportPaymentMethods: Set<String>
    var supportCards: Set<String>
    var supportApplePayCards: Set<String>
    
    static func from(json: NSDictionary?) -> PaymentMethodConfig {
        //let supportPaymentMethod = json?["support_payment_method"] as? [String]
        var supportPaymentMethods: Set<String> = []
        var supportCards: Set<String> = []
        var supportApplePayCards: Set<String> = []
        
        let dynamicJson = DynamicJson(value: json)
        let arr = dynamicJson["payment_process_rule"].array
        arr.forEach { item in
            let entryTypes = item["payment_entry_types"].array.map({$0.string})
            if entryTypes.contains("cit") && entryTypes.contains("mit") {
                let methods = item["payment_methods"].array.compactMap({$0.string})
                supportCards.formUnion(methods)
            }
            
            if entryTypes.contains("in_app")  {
                let methods = item["payment_methods"].array.compactMap({$0.string})
                supportPaymentMethods.formUnion(methods)
            }
            
            if entryTypes.contains("apple_pay")  {
                let methods = item["payment_methods"].array.compactMap({$0.string})
                supportApplePayCards.formUnion(methods)
            }
        }
        
        if !supportCards.isEmpty {
            supportPaymentMethods.insert(PaymentMethodType.creditCard.rawValue)
        }
        
        if !supportApplePayCards.isEmpty {
            supportPaymentMethods.insert(PaymentMethodType.applePay.rawValue)
        }
        
        return PaymentMethodConfig(
            supportPaymentMethods: supportPaymentMethods,
            supportCards: supportCards,
            supportApplePayCards: supportApplePayCards
        )
    }
    
}
