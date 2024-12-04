
class AdService {
    static var domain: String {
        switch(WonderPayment.paymentConfig.environment) {
        case .staging:
            return "gateway-stg.wonder.app"
        case .alpha:
            return "gateway-alpha.wonder.app"
        case .production:
            return "gateway.wonder.app"
        }
    }
    
    static func getBannerData(
        completion: @escaping ([AdItem]?, ErrorMessage?) -> Void
    ) {
        let appId = WonderPayment.paymentConfig.appId
        let urlString = "https://\(domain)/api/registry/advertise?os=iOS&app_slug=Payment&app_id=\(appId)"
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil, .unknownError) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("22", forHTTPHeaderField: "X-Platform-From")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(WonderPayment.paymentConfig.locale.rawValue, forHTTPHeaderField: "x-i18n-lang")
        request.setValue(WonderPayment.paymentConfig.customerId, forHTTPHeaderField: "X-P-Customer-Uuid")
        
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
                    let dataJson = DynamicJson(value: resp.data)
                    let items = AdItem.from(jsonArray: dataJson.array.compactMap({$0.value}) as? NSArray)
                    UI.call { completion(items, nil) }
                } else {
                    UI.call { completion(nil, resp.error) }
                }
            } catch {
                UI.call { completion(nil, .dataFormatError) }
            }
        }
        
        task.resume()
    }
    
    static func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            UI.call { completion(nil) }
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else {
                UI.call { completion(nil) }
                return
            }
            UI.call { completion(image) }
        }
        
        task.resume()
    }
}
