
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
    
    static func getBannerData() async -> Result<String, Error> {
        let appId = WonderPayment.paymentConfig.appId
        let urlString = "https://\(domain)/api/registry/advertise?os=iOS&app_slug=\(appId)&app_id=\(appId)"
        guard let url = URL(string: urlString) else {
            return .failure(ErrorMessage.unknownError)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("22", forHTTPHeaderField: "X-Platform-From")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(WonderPayment.paymentConfig.locale.rawValue, forHTTPHeaderField: "x-i18n-lang")
        request.setValue(WonderPayment.paymentConfig.customerId, forHTTPHeaderField: "X-P-Customer-Uuid")
        
        guard let (data, response) = try? await URLSession.shared.data(for: request) else {
            return .failure(ErrorMessage.networkError)
        }
        
        let dataString = String(data: data, encoding: .utf8)!
        return .success(dataString)
    }
}
