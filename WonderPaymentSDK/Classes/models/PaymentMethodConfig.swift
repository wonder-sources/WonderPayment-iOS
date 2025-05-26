
struct PaymentMethodConfig: JSONDecodable {
    
    private var allMethods: Dictionary<String, Array<String>>
    
    func isSupport(method: String, transactionType: TransactionType) -> Bool {
        let methods = getSupportPaymentMethods(transactionType: transactionType)
        let gatewayConfigured = methods.contains(method)
        switch(method) {
        case PaymentMethodType.applePay.rawValue:
            let applePayConfigured = WonderPayment.paymentConfig.applePay != nil
            return gatewayConfigured && applePayConfigured
        case PaymentMethodType.wechat.rawValue:
            let wechatPayConfigured = WonderPayment.paymentConfig.wechat != nil
            return gatewayConfigured && wechatPayConfigured
        case PaymentMethodType.alipay.rawValue:
            return gatewayConfigured && isAlipayInstalled
        case PaymentMethodType.alipayHK.rawValue:
            return gatewayConfigured && isAlipayHKInstalled
        default:
            return gatewayConfigured
        }
    }
    
    func getEntryTypes(method: String) -> Array<String>? {
        // 支付网关的支付方式配置里，没有将alipay和alipayHK做区分，暂且这样处理
        var method = method
        if method == "alipay_hk" {
            method = "alipay"
        }
        return allMethods[method]
    }
    
    func isSupportPreAuth(method: String) -> Bool {
        if let entryTypes = getEntryTypes(method: method) {
            let entrySet = Set(entryTypes)
            return entrySet.isSuperset(of: ["cit", "mit"])
        }
        return false
    }
    
    func isSupportInApp(method: String) -> Bool {
        if let entryTypes = getEntryTypes(method: method) {
            return entryTypes.contains("in_app")
        }
        return false
    }
    
    func getSupportCards(transactionType: TransactionType) -> Set<String> {
        var cards: Set<String> = []
        let brands = ["visa","mastercard","cup","jcb","discover","diners","amex"]
        for brand in brands {
            if transactionType == .preAuth {
                if isSupportPreAuth(method: brand) {
                    cards.insert(brand)
                }
            } else {
                cards.insert(brand)
            }
        }
        return cards
    }
    
    func getSupportApplePayCards(transactionType: TransactionType) -> Set<String> {
        var cards: Set<String> = []
        let brands = ["visa","mastercard","cup","jcb","discover","diners","amex"]
        for brand in brands {
            if let entryTypes = allMethods[brand], entryTypes.contains("apple_pay") {
                if transactionType == .preAuth {
                    if isSupportPreAuth(method: brand) {
                        cards.insert(brand)
                    }
                } else {
                    cards.insert(brand)
                }
            }
        }
        return cards
    }

    func getSupportPaymentMethods(transactionType: TransactionType) -> Set<String> {
        var supportMethods: Set<String> = []
        let methods = ["unionpay_wallet","wechat","alipay","alipay_hk","fps","octopus","payme"]
        let localPreAuthSupport: Set<String> = [/*"alipay_hk"*/]
        for method in methods {
            if transactionType == .preAuth {
                if isSupportPreAuth(method: method) && localPreAuthSupport.contains(method) {
                    supportMethods.insert(method)
                }
            } else {
                //仅支持AutoDebit或者支持InApp的支付方式都展示
                if isSupportPreAuth(method: method) || isSupportInApp(method: method) {
                    supportMethods.insert(method)
                }
            }
        }
        if !getSupportCards(transactionType: transactionType).isEmpty {
            supportMethods.insert("credit_card")
        }
        if !getSupportApplePayCards(transactionType: transactionType).isEmpty {
            supportMethods.insert("apple_pay")
        }
        return supportMethods
    }
    
    static func from(json: NSDictionary?) -> PaymentMethodConfig {
        let dynamicJson = DynamicJson(value: json)
        let rules = dynamicJson["payment_process_rule"].array
        
        var allMethods: Dictionary<String, Array<String>> = [:]
        for rule in rules {
            let entryTypes = rule["payment_entry_types"].array.compactMap({$0.string})
            let methods = rule["payment_methods"].array.compactMap({$0.string})
            for method in methods {
                if allMethods[method] == nil {
                    allMethods[method] = entryTypes
                } else {
                    allMethods[method]?.append(contentsOf: entryTypes)
                }
            }
        }
        
        return PaymentMethodConfig(
            allMethods: allMethods
        )
    }
    
}
