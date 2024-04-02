
public class PaymentConfig : JSONDecodable, JSONEncodable {
    public var businessId: String = ""
    public var source: String = ""
    public var token: String = ""
    public var scheme: String = ""
    public var environment: PaymentEnvironment = .production
    public var locale: Locale = .zh_HK
    public var wechat: WechatConfig?
    public var applePay: ApplePayConfig?
    
    public static func from(json: NSDictionary?) -> Self {
        let config = PaymentConfig()
        config.businessId = json?["businessId"] as? String ?? ""
        config.source = json?["source"] as? String ?? ""
        config.token = json?["token"] as? String ?? ""
        config.scheme = json?["scheme"] as? String ?? ""
        config.environment = PaymentEnvironment(rawValue: json?["environment"] as? String ?? "") ?? .production
        config.locale = Locale(rawValue: json?["locale"] as? String ?? "") ?? .zh_HK
        config.wechat = WechatConfig.from(json: json?["wechat"] as? NSDictionary)
        config.applePay = ApplePayConfig.from(json: json?["applePay"] as? NSDictionary)
        return config as! Self
    }
    
    public func toJson() -> Dictionary<String, Any?> {
        return [
            "businessId": businessId,
            "source": source,
            "token": token,
            "scheme": scheme,
            "environment": environment.rawValue,
            "locale": locale.rawValue,
            "wechat": wechat?.toJson(),
            "applePay": applePay?.toJson(),
        ]
    }
}

/// 相关配置参考 https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/iOS.html
public class WechatConfig : JSONDecodable, JSONEncodable {
    public var appId: String = ""
    public var universalLink: String = ""
    
    public init(appId: String, universalLink: String) {
        self.appId = appId
        self.universalLink = universalLink
    }
    
    public static func from(json: NSDictionary?) -> Self {
        return WechatConfig(
            appId: json?["appId"] as? String ?? "",
            universalLink: json?["universalLink"] as? String ?? ""
        ) as! Self
    }
    
    public func toJson() -> Dictionary<String, Any?> {
        return [
            "appId": appId,
            "universalLink": universalLink,
        ]
    }
}

public class ApplePayConfig : JSONDecodable, JSONEncodable {
    /// Apple Developer 后台申请的商户ID
    public var merchantIdentifier: String = ""
    /// 两位国家码 CN, HK, US ...
    public var countryCode: String = ""
    
    public init(merchantIdentifier: String, countryCode: String) {
        self.merchantIdentifier = merchantIdentifier
        self.countryCode = countryCode
    }
    
    public static func from(json: NSDictionary?) -> Self {
        return ApplePayConfig(
            merchantIdentifier: json?["merchantIdentifier"] as? String ?? "",
            countryCode: json?["countryCode"] as? String ?? ""
        ) as! Self
    }
    
    public func toJson() -> Dictionary<String, Any?> {
        return [
            "merchantIdentifier": merchantIdentifier,
            "countryCode": countryCode,
        ]
    }
}
