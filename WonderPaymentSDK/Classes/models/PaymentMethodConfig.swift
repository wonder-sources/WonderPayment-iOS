
struct PaymentMethodConfig: JSONDecodable {
    
    var supportPaymentMethods: [String]
    var supportCards: [String]
    var supportApplePayCards: [String]
    
    static func from(json: NSDictionary?) -> PaymentMethodConfig {
        //let supportPaymentMethod = json?["support_payment_method"] as? [String]
        var supportPaymentMethods: [String] = []
        var supportCards: [String] = []
        var supportApplePayCards: [String] = []
        
        let dynamicJson = DynamicJson(value: json)
        let arr = dynamicJson["payment_process_rule"].array
        arr.forEach { item in
            let entryTypes = item["payment_entry_types"]
            if entryTypes.value is NSNull {
                let methods = item["payment_methods"].array.map({$0.string})
                supportPaymentMethods.append(contentsOf: methods.compactMap({$0}))
            } else {
                let list = entryTypes.array.map({$0.string})
                for type in list {
                    let methods = item["payment_methods"].array.map({$0.string}).compactMap({$0})
                    if type == "in_app" {
                        supportPaymentMethods.append(contentsOf: methods)
                    } else if type == "apple_pay" {
                        supportApplePayCards.append(contentsOf: methods)
                    } else if type == "manual" {
                        supportCards.append(contentsOf: methods)
                    }
                }
            }
        }
        
        if !supportCards.isEmpty {
            supportPaymentMethods.append(PaymentMethodType.creditCard.rawValue)
        }
        
        if !supportApplePayCards.isEmpty {
            supportPaymentMethods.append(PaymentMethodType.applePay.rawValue)
        }
        
        return PaymentMethodConfig(
            supportPaymentMethods: supportPaymentMethods,
            supportCards: supportCards,
            supportApplePayCards: supportApplePayCards
        )
    }
    
}
