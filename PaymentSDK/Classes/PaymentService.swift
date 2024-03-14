class PaymentService {
    static var domain: String {
        switch(WonderPayment.paymentConfig.environment) {
        case .staging:
            return "gateway-stg.wonder.today"
        case .alpha:
            return "gateway-alpha.wonder.today"
        case .production:
            return "gateway.wonder.today"
        }
    }
    
    static func queryPaymentMethods(businessId: String, completion: @escaping (PaymentMethodConfig?, ErrorMessage?) -> Void) {
        let urlString = "https://\(domain)/svc/oms/public/api/v1/payment_sdk/payment_methods"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(businessId, forHTTPHeaderField: "x-p-business-id")
        request.setValue(WonderPayment.paymentConfig.locale.rawValue, forHTTPHeaderField: "x-i18n-lang")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                UI.call { completion(nil, .networkError) }
                return
            }
            
//            prettyPrint(jsonData: data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let resp = PaymentResponse.from(json: json as? NSDictionary)
                if resp.succeed {
                    let config = PaymentMethodConfig.from(json: resp.data as? NSDictionary)
                    UI.call { completion(config, nil) }
                } else {
                    UI.call { completion(nil, resp.error) }
                }
            } catch {
                UI.call { completion(nil, .dataFormatError) }
            }
        }
        task.resume()
    }
    
    
    static func payOrder(
        amount: Double,
        paymentMethod: String,
        paymentData: [String: Any?],
        transactionType: TransactionType = .sale,
        orderNum: String,
        businessId: String,
        completion: @escaping (PayResult?, ErrorMessage?) -> Void
    )  {
        let uuid = UUID().uuidString
        let urlString = "https://\(domain)/svc/oms/public/api/v1/payment_sdk/orders/\(orderNum)/pay"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var paymentArgs = paymentData
        paymentArgs["amount"] = amount
        if transactionType == .preAuth {
            paymentArgs["consume_mode"] = "pre_authorize"
        }
        
        let params: [String: Any] = [
            "payment": [
                "uuid": uuid,
                paymentMethod: [paymentArgs]
            ]
        ]
        
        prettyPrint(arrayOrMap: params)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(WonderPayment.paymentConfig.source, forHTTPHeaderField: "X-INTEGRATION-SOURCE")
        request.setValue(WonderPayment.paymentConfig.token, forHTTPHeaderField: "X-INTEGRATION-CUSTOMER")
        request.setValue(businessId, forHTTPHeaderField: "x-p-business-id")
        request.setValue(WonderPayment.paymentConfig.locale.rawValue, forHTTPHeaderField: "x-i18n-lang")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            UI.call { completion(nil, .dataFormatError) }
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                UI.call { completion(nil, .networkError) }
                return
            }
            
            prettyPrint(jsonData: data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let resp = PaymentResponse.from(json: json as? NSDictionary)
                if resp.succeed {
                    let result = PayResult.from(json: resp.data as? NSDictionary)
                    UI.call { completion(result, nil) }
                } else {
                    UI.call { completion(nil, resp.error) }
                }
            } catch {
                UI.call { completion(nil, .dataFormatError) }
            }
        }
        task.resume()
    }
    
    static func queryCardList(limit: Int = 1000, completion: @escaping ([CreditCardInfo]?, ErrorMessage?) -> Void) {
        let urlString = "https://\(domain)/svc/oms/public/api/v1/payment_sdk/credit_cards/list?limit=\(limit)"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(WonderPayment.paymentConfig.source, forHTTPHeaderField: "X-INTEGRATION-SOURCE")
        request.setValue(WonderPayment.paymentConfig.token, forHTTPHeaderField: "X-INTEGRATION-CUSTOMER")
        request.setValue(WonderPayment.paymentConfig.locale.rawValue, forHTTPHeaderField: "x-i18n-lang")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                UI.call { completion(nil, .networkError) }
                return
            }
            
//            prettyPrint(jsonData: data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let resp = PaymentResponse.from(json: json as? NSDictionary)
                if resp.succeed {
                    let cardList = CreditCardInfo.from(jsonArray: resp.data as? NSArray)
                    UI.call { completion(cardList , nil) }
                } else {
                    UI.call { completion(nil, resp.error) }
                }
            } catch {
                UI.call { completion(nil, .dataFormatError) }
            }
        }
        task.resume()
    }
    
    static func bindCard(creditCardArgs: Dictionary<String, String>, completion: @escaping (CreditCardInfo?, ErrorMessage?) -> Void) {
        let urlString = "https://\(domain)/svc/oms/public/api/v1/payment_sdk/credit_cards/bind"
        print("bindCard-url", urlString)
        
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        let expiryDate = creditCardArgs["expiryDate"]!
        let firstName = creditCardArgs["firstName"]!
        let lastName = creditCardArgs["lastName"]!
        let expiry = expiryDate.replacingOccurrences(of: "/", with: "")
        let params: [String: Any?] = [
            "exp_date": expiry,
            "exp_year": expiry.prefix(2),
            "exp_month": expiry.suffix(2),
            "number": creditCardArgs["cardNumber"],
            "cvv": creditCardArgs["cvv"],
            "holder_name": "\(firstName) \(lastName)",
            "default": true,
            "billing_address": [
                "first_name": firstName,
                "last_name" : lastName,
                "phone_number" : creditCardArgs["phoneNumber"]
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(WonderPayment.paymentConfig.source, forHTTPHeaderField: "X-INTEGRATION-SOURCE")
        request.setValue(WonderPayment.paymentConfig.token, forHTTPHeaderField: "X-INTEGRATION-CUSTOMER")
        request.setValue(WonderPayment.paymentConfig.locale.rawValue, forHTTPHeaderField: "x-i18n-lang")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            UI.call { completion(nil, .dataFormatError) }
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                UI.call { completion(nil, .networkError) }
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let resp = PaymentResponse.from(json: json as? NSDictionary)
                if resp.succeed {
                    let card = CreditCardInfo.from(json: resp.data as? NSDictionary)
                    UI.call { completion(card, nil) }
                } else {
                    UI.call { completion(nil, resp.error) }
                }
                
            } catch {
                UI.call { completion(nil, .dataFormatError) }
            }
        }
        task.resume()
    }
    
    static func getPayResult(
        uuid: String,
        orderNum: String,
        businessId: String,
        completion: @escaping (PayResult?, ErrorMessage?) -> Void
    ){
        let urlString = "https://\(domain)/svc/oms/public/api/v1/payment_sdk/orders/\(orderNum)/transactions/\(uuid)"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(WonderPayment.paymentConfig.source, forHTTPHeaderField: "X-INTEGRATION-SOURCE")
        request.setValue(WonderPayment.paymentConfig.token, forHTTPHeaderField: "X-INTEGRATION-CUSTOMER")
        request.setValue(businessId, forHTTPHeaderField: "x-p-business-id")
        request.setValue(WonderPayment.paymentConfig.locale.rawValue, forHTTPHeaderField: "x-i18n-lang")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                UI.call { completion(nil, .networkError) }
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let resp = PaymentResponse.from(json: json as? NSDictionary)
                if resp.succeed {
                    let result = PayResult.from(json: resp.data as? NSDictionary)
                    
                    UI.call { completion(result, nil) }
                } else {
                    UI.call { completion(nil, resp.error) }
                }
            } catch {
                UI.call { completion(nil, .dataFormatError) }
            }
        }
        
        task.resume()
    }
    
    /// 轮询支付结果
    static func loopForResult(
        uuid: String,
        orderNum: String,
        businessId: String,
        completion: @escaping (PayResult?, ErrorMessage?) -> Void
    ) {
        getPayResult(uuid: uuid, orderNum: orderNum, businessId: businessId) { result, error in
            if let result = result, let isPending = result.isPending {
                if isPending  {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        loopForResult(uuid: uuid, orderNum: orderNum, businessId: businessId, completion: completion)
                    })
                } else {
                    completion(result, error)
                }
            } else {
                completion(result, error)
            }
        }
    }
}
