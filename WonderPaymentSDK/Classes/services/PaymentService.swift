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
        dateFormatter.locale = Foundation.Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: Date())
    }
    
    static var credential: String {
        return "\(appId)/\(requestTime)/Wonder-HMAC-SHA256"
    }
    
    static var appId: String {
        return WonderPayment.paymentConfig.appId
    }
    
    private static let sharedSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        return URLSession(configuration: config)
    }()
    
    static func setGlobalHeaders(forRequest request: inout URLRequest) {
        request.setValue("22", forHTTPHeaderField: "X-Platform-From")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(credential, forHTTPHeaderField: "Credential")
        request.setValue(WonderPayment.paymentConfig.locale.rawValue, forHTTPHeaderField: "X-I18n-Lang")
        request.setValue(WonderPayment.paymentConfig.customerId, forHTTPHeaderField: "X-P-Customer-Uuid")
        request.setValue(WonderPayment.paymentConfig.originalBusinessId, forHTTPHeaderField: "X-Original-Business-Id")
        request.setValue(generateUUID(), forHTTPHeaderField: "X-Request-Id")
        request.setValue(deviceId, forHTTPHeaderField: "X-User-Device-Id")
        request.setValue(deviceModel, forHTTPHeaderField: "X-User-Device-Model")
        request.setValue(WonderPayment.sdkVersion, forHTTPHeaderField: "X-Sdk-Version")
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
        setGlobalHeaders(forRequest: &request)
        
        let task = sharedSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                UI.call { completion(nil, .networkError) }
                return
            }
            
//            prettyPrint(jsonData: data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let resp = CommonResponse.from(json: json as? NSDictionary)
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
        setGlobalHeaders(forRequest: &request)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: profile, options: [])
        } catch {
            UI.call { completion(nil, .dataFormatError) }
            return
        }
        
        let task = sharedSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                UI.call { completion(nil, .networkError) }
                return
            }
            
//            prettyPrint(jsonData: data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let resp = CommonResponse.from(json: json as? NSDictionary)
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
        setGlobalHeaders(forRequest: &request)
        
        let task = sharedSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                UI.call { completion(nil, .networkError) }
                return
            }
            
//            prettyPrint(jsonData: data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let resp = CommonResponse.from(json: json as? NSDictionary)
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
    
    ///查询支付方式
    static func queryPaymentMethods() -> Future<PaymentMethodConfig> {
        return Future<PaymentMethodConfig> { resolve, reject in
            queryPaymentMethods() { data, error in
                if let data {
                    resolve(data)
                } else if let error {
                    reject(error)
                } else {
                    reject(ErrorMessage.unknownError)
                }
            }
        }
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
        setGlobalHeaders(forRequest: &request)
        
//        prettyPrint(arrayOrMap: paymentArgs)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: paymentArgs, options: [])
        } catch {
            UI.call { completion(nil, .dataFormatError) }
            return
        }
        
        
        let task = sharedSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                UI.call { completion(nil, .networkError) }
                return
            }
            
//            prettyPrint(jsonData: data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let resp = CommonResponse.from(json: json as? NSDictionary)
                if resp.succeed {
                    var result = PayResult.from(json: resp.data as? NSDictionary)
                    result.transaction = result.order.transactions?.first(where: {$0.uuid == uuid})
                    
                    let sessionId = intent.extra?.sessionId
                    SessionManager.shared.createSession(sessionId, orderNumber: intent.orderNumber, transactionId: uuid)
                    
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
    
    
    /// 查询PaymentTokens
    static func queryPaymentTokens() -> Future<[DynamicJson]> {
        return Future { resolve, reject in
            queryPaymentTokens { tokens, error in
                if let tokens {
                    resolve(tokens)
                } else if let error {
                    reject(error)
                } else {
                    reject(ErrorMessage.unknownError)
                }
            }
        }
    }
    
    /// 查询PaymentTokens
    static func queryPaymentTokens(completion: @escaping ([DynamicJson]?, ErrorMessage?) -> Void) {
        let customerId = WonderPayment.paymentConfig.customerId
        if customerId.isEmpty {
            UI.call { completion(nil, .none) }
            return
        }
        let urlString = "https://\(domain)/svc/payment/public/api/v1/openapi/customers/\(customerId)/payment_tokens"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        setGlobalHeaders(forRequest: &request)
        
        let task = sharedSession.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                UI.call { completion(nil, .networkError) }
                return
            }
            
//            prettyPrint(jsonData: data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let resp = CommonResponse.from(json: json as? NSDictionary)
                if resp.succeed {
                    let tokens = DynamicJson(value: resp.data)["payment_tokens"].array
                    UI.call { completion(tokens , nil) }
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
        queryPaymentTokens { tokens, error in
            if let tokens {
                let arr = tokens.filter({
                    $0["token_type"].string == "CreditCard" && $0["state"].string == "success"
                }).map({$0.value})
                let cardList = CreditCardInfo.from(jsonArray: arr as NSArray)
                completion(cardList, nil)
            } else {
                completion(nil, error)
            }
        }
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
        setGlobalHeaders(forRequest: &request)
        
        var dataParams: [String: Any] = [
            "card": ["3ds": _3dsConfig].merge(cardInfo)
        ]
        
        do {
            dataParams = try EncryptionUtil.encrypt(content: dataParams)
        } catch {
            let err = ErrorMessage(code: "E100004", message: error.localizedDescription)
            UI.call { completion(nil, err) }
            return
        }
        
//        prettyPrint(arrayOrMap: dataParams)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: dataParams, options: [])
        } catch {
            UI.call { completion(nil, .dataFormatError) }
            return
        }
        

        let task = sharedSession.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                UI.call { completion(nil, .networkError) }
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                prettyPrint(arrayOrMap: json)
                let resp = CommonResponse.from(json: json as? NSDictionary)
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
        setGlobalHeaders(forRequest: &request)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ["token": token], options: [])
        } catch {
            UI.call { completion(nil, .dataFormatError) }
            return
        }
        
        let task = sharedSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                UI.call { completion(nil, .networkError) }
                return
            }
            
//            prettyPrint(jsonData: data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let resp = CommonResponse.from(json: json as? NSDictionary)
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
    
    /// 删除PaymentToken
    static func deletePaymentToken(token: String) -> Future<Bool> {
        return Future<Bool> { resolve, reject in
            deletePaymentToken(token: token) { data, error in
                if let data {
                    resolve(data)
                } else if let error {
                    reject(error)
                } else {
                    reject(ErrorMessage.unknownError)
                }
            }
        }
    }
    
    ///创建PaymentToken
    static func createPaymentToken(args: NSDictionary, completion: @escaping (DynamicJson?, ErrorMessage?) -> Void) {
        let customerId = WonderPayment.paymentConfig.customerId
        
        let urlString = "https://\(domain)/svc/payment/public/api/v1/openapi/customers/\(customerId)/payment_tokens"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        setGlobalHeaders(forRequest: &request)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: args, options: [])
        } catch {
            UI.call { completion(nil, .dataFormatError) }
            return
        }
        
        let task = sharedSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                UI.call { completion(nil, .networkError) }
                return
            }
            
//            prettyPrint(jsonData: data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let resp = CommonResponse.from(json: json as? NSDictionary)
                if resp.succeed {
                    let dataJson = resp.data as? NSDictionary
                    let token = dataJson?["payment_token"] as? NSDictionary
                    UI.call { completion(DynamicJson(value: token), nil) }
                } else {
                    UI.call { completion(nil, resp.error) }
                }
            } catch {
                UI.call { completion(nil, .dataFormatError) }
            }
        }
        
        task.resume()
    }
    
    ///创建PaymentToken
    static func createPaymentToken(args: NSDictionary) -> Future<DynamicJson> {
        return Future<DynamicJson> { resolve, reject in
            createPaymentToken(args: args) { data, error in
                if let data {
                    resolve(data)
                } else if let error {
                    reject(error)
                } else {
                    reject(ErrorMessage.unknownError)
                }
            }
        }
    }
    
    /// 检查PaymentToken是否已验证
    static func checkPaymentToken(
        uuid: String,
        token: String,
        completion: @escaping (DynamicJson?, ErrorMessage?) -> Void
    ) {
        let customerId = WonderPayment.paymentConfig.customerId
        let urlString = "https://\(domain)/svc/payment/public/api/v1/openapi/customers/\(customerId)/payment_tokens/check"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        setGlobalHeaders(forRequest: &request)
        
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
        
        
        let task = sharedSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                UI.call { completion(nil, .networkError) }
                return
            }
            
//            prettyPrint(jsonData: data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let resp = CommonResponse.from(json: json as? NSDictionary)
                if resp.succeed {
                    let dataJson = DynamicJson(value: resp.data)
                    UI.call { completion(dataJson["payment_token"], nil) }
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
        setGlobalHeaders(forRequest: &request)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: [
                "order": ["number": orderNum]
            ], options: [])
        } catch {
            UI.call { completion(nil, .dataFormatError) }
            return
        }
        
        
        let task = sharedSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                UI.call { completion(nil, .networkError) }
                return
            }
            
//            prettyPrint(jsonData: data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let resp = CommonResponse.from(json: json as? NSDictionary)
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
    
    /// 获取支付结果
    static func getPayResult(
        sessionId: String,
        completion: @escaping (PaymentResultStatus?, ErrorMessage?) -> Void
    ){
        guard let sessionData = SessionManager.shared.getSessionData(sessionId) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        let urlString = "https://\(domain)/svc/payment/public/api/v1/openapi/orders/check"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        setGlobalHeaders(forRequest: &request)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: [
                "order": ["number": sessionData.orderNumber]
            ], options: [])
        } catch {
            UI.call { completion(nil, .dataFormatError) }
            return
        }
        
        
        let task = sharedSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                UI.call { completion(nil, .networkError) }
                return
            }
            
//            prettyPrint(jsonData: data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let resp = CommonResponse.from(json: json as? NSDictionary)
                if resp.succeed {
                    let result = PayResult.from(json: resp.data as? NSDictionary)
                    let transactions = result.order.transactions?.filter({ sessionData.transactions.contains($0.uuid) })
                    if transactions?.contains(where: {$0.success}) ?? false {
                        UI.call { completion(.completed, nil) }
                    } else {
                        UI.call { completion(.pending, nil) }
                    }
                } else {
                    UI.call { completion(nil, resp.error) }
                }
            } catch {
                UI.call { completion(nil, .dataFormatError) }
            }
        }
        
        task.resume()
    }
    
    /// 获取商户配置
    static func getSDKConfig(
        completion: @escaping (NSDictionary?, ErrorMessage?) -> Void
    ){
        
        let urlString = "https://\(domain)/svc/payment/public/api/v1/openapi/payment_sdk_configure"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        setGlobalHeaders(forRequest: &request)
        
        
        let task = sharedSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                UI.call { completion(nil, .networkError) }
                return
            }
            
//            prettyPrint(jsonData: data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let resp = CommonResponse.from(json: json as? NSDictionary)
                if resp.succeed {
                    let data = resp.data as? NSDictionary
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
    
    
    /// 获取订单详情
    static func getOrderDetail(orderNum: String) -> Future<DynamicJson> {
        return Future { resolve, reject in
            getOrderDetail(orderNum: orderNum) { data, error in
                if let data {
                    resolve(data)
                } else if let error {
                    reject(error)
                } else {
                    reject(ErrorMessage.unknownError)
                }
            }
        }
    }
    
    /// 获取订单详情
    static func getOrderDetail(
        orderNum: String,
        completion: @escaping (DynamicJson?, ErrorMessage?) -> Void
    ){
        let urlString = "https://\(domain)/svc/payment/public/api/v1/openapi/orders/check"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        setGlobalHeaders(forRequest: &request)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: [
                "order": ["number": orderNum]
            ], options: [])
        } catch {
            UI.call { completion(nil, .dataFormatError) }
            return
        }
        
        
        let task = sharedSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                UI.call { completion(nil, .networkError) }
                return
            }
            
//            prettyPrint(jsonData: data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let resp = CommonResponse.from(json: json as? NSDictionary)
                if resp.succeed {
                    let dataJson = DynamicJson(value: resp.data)
                    let orderJson = dataJson["order"]
                    UI.call { completion(orderJson, nil) }
                } else {
                    UI.call { completion(nil, resp.error) }
                }
            } catch {
                UI.call { completion(nil, .dataFormatError) }
            }
        }
        
        task.resume()
    }
    
    
    ///AlipayHK签约
    static func alipayAuthApply(
        merchantAgreementId: String,
        authCode: String,
        completion: @escaping (DynamicJson?, ErrorMessage?) -> Void)
    {
        let query = "merchantAgreementId=\(merchantAgreementId)&authCode=\(authCode)"
        let urlString = "https://\(domain)/svc/payment/public/api/v1/openapi/alipay_auto_debit/auth_apply?\(query)"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        setGlobalHeaders(forRequest: &request)
        
        let task = sharedSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                UI.call { completion(nil, .networkError) }
                return
            }
            
//            prettyPrint(jsonData: data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let resp = CommonResponse.from(json: json as? NSDictionary)
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
    
    ///AlipayHK签约
    static func alipayAuthApply(
        merchantAgreementId: String,
        authCode: String
    ) -> Future<DynamicJson> {
        return Future<DynamicJson> { resolve, reject in
            alipayAuthApply(merchantAgreementId: merchantAgreementId, authCode: authCode) { data, error in
                if let data {
                    resolve(data)
                } else if let error {
                    reject(error)
                } else {
                    reject(ErrorMessage.unknownError)
                }
            }
        }
    }
    
    ///获取FPS应用列表
    static func getFPSApps(completion: @escaping (DynamicJson?, ErrorMessage?) -> Void) {
        let urlString = "https://fps.payapps.hkicl.com.hk/build/data.json"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = sharedSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                UI.call { completion(nil, .networkError) }
                return
            }
            
//            prettyPrint(jsonData: data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                UI.call { completion(DynamicJson(value: json), nil) }
            } catch {
                UI.call { completion(nil, .dataFormatError) }
            }
        }
        task.resume()
    }
    
    ///获取FPS应用列表
    static func getFPSApps() -> Future<DynamicJson> {
        return Future<DynamicJson> { resolve, reject in
            getFPSApps() { data, error in
                if let data {
                    resolve(data)
                } else if let error {
                    reject(error)
                } else {
                    reject(ErrorMessage.unknownError)
                }
            }
        }
    }
}
