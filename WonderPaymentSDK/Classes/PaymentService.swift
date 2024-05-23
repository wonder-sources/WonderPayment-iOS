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
    
    static var _3dsConfig: NSDictionary {
        let host: String
        switch(WonderPayment.paymentConfig.environment) {
        case .staging:
            host = "pay-stg.wonder.app"
        case .alpha:
            host = "pay-alpha.wonder.app"
        case .production:
            host = "pay.wonder.app"
        }
        var lang = "en"
        let locale = WonderPayment.paymentConfig.locale
        if locale != .en_US {
            lang = locale.rawValue
        }
        
        return [
            "success_return_url": "https://\(host)/\(lang)/payment/3ds/auth/successful",
            "fail_return_url": "https://\(host)/\(lang)/payment/3ds/auth/failed",
        ]
    }
    
    static var requestTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return dateFormatter.string(from: Date())
    }
    
    static var credential: String {
        return "\(appId)/\(requestTime)/Wonder-HMAC-SHA256"
    }
    
    static var appId: String {
        return WonderPayment.paymentConfig.appId
    }
    
    ///获取默认支付方式
    static func getCustomerProfile(completion: @escaping (DynamicJson?, ErrorMessage?) -> Void) {
        let customerId = WonderPayment.paymentConfig.customerId
        let urlString = "https://\(domain)/svc/payment/public/api/v1/openapi/customers/\(customerId)"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("22", forHTTPHeaderField: "X-Platform-From")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(credential, forHTTPHeaderField: "Credential")
        request.setValue(WonderPayment.paymentConfig.locale.rawValue, forHTTPHeaderField: "x-i18n-lang")
        request.setValue(WonderPayment.paymentConfig.customerId, forHTTPHeaderField: "X-P-Customer-Uuid")
        
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
                    let data = DynamicJson(value: resp.data)
                    UI.call { completion(data, nil) }
                } else {
                    UI.call { completion(nil, resp.error) }
                }
            } catch {
                UI.call { completion(nil, .dataFormatError) }
            }
        }
        task.resume()
    }
    
    ///设置支付方式
    static func setCustomerProfile(
        _ profile: NSDictionary,
        completion: @escaping (Bool?, ErrorMessage?) -> Void
    ) {
        let customerId = WonderPayment.paymentConfig.customerId
        let urlString = "https://\(domain)/svc/payment/public/api/v1/openapi/customers/\(customerId)"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("22", forHTTPHeaderField: "X-Platform-From")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(credential, forHTTPHeaderField: "Credential")
        request.setValue(WonderPayment.paymentConfig.locale.rawValue, forHTTPHeaderField: "x-i18n-lang")
        request.setValue(WonderPayment.paymentConfig.customerId, forHTTPHeaderField: "X-P-Customer-Uuid")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: profile, options: [])
        } catch {
            UI.call { completion(nil, .dataFormatError) }
            return
        }
        
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
                    UI.call { completion(true, nil) }
                } else {
                    UI.call { completion(nil, resp.error) }
                }
            } catch {
                UI.call { completion(nil, .dataFormatError) }
            }
        }
        task.resume()
    }
    
    ///查询支付方式
    static func queryPaymentMethods(completion: @escaping (PaymentMethodConfig?, ErrorMessage?) -> Void) {
        let urlString = "https://\(domain)/svc/payment/public/api/v1/openapi/payment_methods"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("22", forHTTPHeaderField: "X-Platform-From")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(credential, forHTTPHeaderField: "Credential")
        request.setValue(WonderPayment.paymentConfig.locale.rawValue, forHTTPHeaderField: "x-i18n-lang")
        request.setValue(WonderPayment.paymentConfig.customerId, forHTTPHeaderField: "X-P-Customer-Uuid")
        
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
    
    /// 支付
    static func payOrder(
        intent: PaymentIntent,
        completion: @escaping (PayResult?, ErrorMessage?) -> Void
    )  {
        
        let uuid = UUID().uuidString.lowercased()
        let paymentArgs: [String: Any] = [
            "number": intent.orderNumber,
            "payment": ["uuid": uuid].merge(intent.paymentMethod?.arguments),
            "additional_line_items": intent.lineItems?.map({$0.toJson()}) ?? [],
        ]
        
        let urlString = "https://\(domain)/svc/payment/public/api/v1/openapi/payments"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("22", forHTTPHeaderField: "X-Platform-From")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(credential, forHTTPHeaderField: "Credential")
        request.setValue(WonderPayment.paymentConfig.locale.rawValue, forHTTPHeaderField: "x-i18n-lang")
        request.setValue(WonderPayment.paymentConfig.customerId, forHTTPHeaderField: "X-P-Customer-Uuid")
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: paymentArgs, options: [])
        } catch {
            UI.call { completion(nil, .dataFormatError) }
            return
        }
        
        
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
                    var result = PayResult.from(json: resp.data as? NSDictionary)
                    result.transaction = result.order.transactions?.first(where: {$0.uuid == uuid})
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
    
    /// 查询卡片列表
    static func queryCardList(completion: @escaping ([CreditCardInfo]?, ErrorMessage?) -> Void) {
        let customerId = WonderPayment.paymentConfig.customerId
        let urlString = "https://\(domain)/svc/payment/public/api/v1/openapi/customers/\(customerId)/payment_tokens"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("22", forHTTPHeaderField: "X-Platform-From")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(credential, forHTTPHeaderField: "Credential")
        request.setValue(WonderPayment.paymentConfig.locale.rawValue, forHTTPHeaderField: "x-i18n-lang")
        request.setValue(WonderPayment.paymentConfig.customerId, forHTTPHeaderField: "X-P-Customer-Uuid")
        
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
                    let list = DynamicJson(value: resp.data)["payment_tokens"].array
                    let arr = list.filter({
                        $0["token_type"].string == "CreditCard" && $0["state"].string == "success"
                    }).map({$0.value})
                    let cardList = CreditCardInfo.from(jsonArray: arr as NSArray)
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
    
    /// 绑定卡片
    static func bindCard(cardInfo: NSDictionary, completion: @escaping (CreditCardInfo?, ErrorMessage?) -> Void) {
        let customerId = WonderPayment.paymentConfig.customerId
        let urlString = "https://\(domain)/svc/payment/public/api/v1/openapi/customers/\(customerId)/payment_tokens"
        
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("22", forHTTPHeaderField: "X-Platform-From")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(credential, forHTTPHeaderField: "Credential")
        request.setValue(WonderPayment.paymentConfig.locale.rawValue, forHTTPHeaderField: "x-i18n-lang")
        request.setValue(WonderPayment.paymentConfig.customerId, forHTTPHeaderField: "X-P-Customer-Uuid")
        
        let dataParams = [
            "card": ["3ds": _3dsConfig].merge(cardInfo)
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: dataParams, options: [])
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
//                prettyPrint(arrayOrMap: json)
                let resp = PaymentResponse.from(json: json as? NSDictionary)
                if resp.succeed {
                    let dataJson = resp.data as? NSDictionary
                    let card = CreditCardInfo.from(json: dataJson?["payment_token"] as? NSDictionary)
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
    
    /// 删除PaymentToken
    static func deletePaymentToken(token: String, completion: @escaping (Bool?, ErrorMessage?) -> Void) {
        let customerId = WonderPayment.paymentConfig.customerId
        
        let urlString = "https://\(domain)/svc/payment/public/api/v1/openapi/customers/\(customerId)/payment_tokens"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("22", forHTTPHeaderField: "X-Platform-From")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(credential, forHTTPHeaderField: "Credential")
        request.setValue(WonderPayment.paymentConfig.locale.rawValue, forHTTPHeaderField: "x-i18n-lang")
        request.setValue(WonderPayment.paymentConfig.customerId, forHTTPHeaderField: "X-P-Customer-Uuid")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ["token": token], options: [])
        } catch {
            UI.call { completion(nil, .dataFormatError) }
            return
        }
        
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
                    let dataJson = resp.data as? NSDictionary
                    let success = dataJson?["success"] as? Bool
                    UI.call { completion(success, nil) }
                } else {
                    UI.call { completion(nil, resp.error) }
                }
            } catch {
                UI.call { completion(nil, .dataFormatError) }
            }
        }
        
        task.resume()
    }
    
    /// 检查PaymentToken是否已验证
    static func checkPaymentTokenState(
        uuid: String,
        token: String,
        completion: @escaping (String?, ErrorMessage?) -> Void
    ) {
        let customerId = WonderPayment.paymentConfig.customerId
        let urlString = "https://\(domain)/svc/payment/public/api/v1/openapi/customers/\(customerId)/payment_tokens/check"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("22", forHTTPHeaderField: "X-Platform-From")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(credential, forHTTPHeaderField: "Credential")
        request.setValue(WonderPayment.paymentConfig.locale.rawValue, forHTTPHeaderField: "x-i18n-lang")
        request.setValue(WonderPayment.paymentConfig.customerId, forHTTPHeaderField: "X-P-Customer-Uuid")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: [
                "payment_token": [
                    "verify_uuid": uuid,
                    "token": token,
                ]
            ], options: [])
        } catch {
            UI.call { completion(nil, .dataFormatError) }
            return
        }
        
        
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
                    let dataJson = DynamicJson(value: resp.data)
                    UI.call { completion(dataJson["payment_token"]["state"].string, nil) }
                } else {
                    UI.call { completion(nil, resp.error) }
                }
            } catch {
                UI.call { completion(nil, .dataFormatError) }
            }
        }
        
        task.resume()
    }
    
    /// 获取支付结果
    static func getPayResult(
        uuid: String,
        orderNum: String,
        completion: @escaping (PayResult?, ErrorMessage?) -> Void
    ){
        let urlString = "https://\(domain)/svc/payment/public/api/v1/openapi/orders/check"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("22", forHTTPHeaderField: "X-Platform-From")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(credential, forHTTPHeaderField: "Credential")
        request.setValue(WonderPayment.paymentConfig.locale.rawValue, forHTTPHeaderField: "x-i18n-lang")
        request.setValue(WonderPayment.paymentConfig.customerId, forHTTPHeaderField: "X-P-Customer-Uuid")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: [
                "order": ["number": orderNum]
            ], options: [])
        } catch {
            UI.call { completion(nil, .dataFormatError) }
            return
        }
        
        
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
                    var result = PayResult.from(json: resp.data as? NSDictionary)
                    result.transaction = result.order.transactions?.first(where: {$0.uuid == uuid})
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
        completion: @escaping (PayResult?, ErrorMessage?) -> Void
    ) {
        getPayResult(uuid: uuid, orderNum: orderNum) { result, error in
            //忽略网络异常
            if error == .networkError {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    loopForResult(uuid: uuid, orderNum: orderNum, completion: completion)
                })
                return
            }
            
            if let transaction = result?.transaction {
                if transaction.isPending  {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        loopForResult(uuid: uuid, orderNum: orderNum, completion: completion)
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
