
public class PaymentConfig : JSONDecodable, JSONEncodable {
    public var appId: String
    public var appSecret: String
    public var customerId: String
    public var scheme: String
    public var environment: PaymentEnvironment
    public var locale: Locale
    public var wechat: WechatConfig?
    public var applePay: ApplePayConfig?
    
    public init(
        appId: String = "",
        appSecret: String = "",
        customerId: String = "",
        scheme: String = "",
        environment: PaymentEnvironment = .production,
        locale: Locale = .zh_HK,
        wechat: WechatConfig? = nil,
        applePay: ApplePayConfig? = nil
    ) {
        self.appId = appId
        self.appSecret = appSecret
        self.customerId = customerId
        self.scheme = scheme
        self.environment = environment
        self.locale = locale
        self.wechat = wechat
        self.applePay = applePay
    }
    
    public static func from(json: NSDictionary?) -> Self {
        let config = PaymentConfig()
        config.appId = json?["appId"] as? String ?? ""
        config.appSecret = json?["appSecret"] as? String ?? ""
        config.customerId = json?["customerId"] as? String ?? ""
        config.scheme = json?["scheme"] as? String ?? ""
        config.environment = PaymentEnvironment(rawValue: json?["environment"] as? String ?? "") ?? .production
        config.locale = Locale(rawValue: json?["locale"] as? String ?? "") ?? .zh_HK
        config.wechat = WechatConfig.from(json: json?["wechat"] as? NSDictionary)
        config.applePay = ApplePayConfig.from(json: json?["applePay"] as? NSDictionary)
        return config as! Self
    }
    
    public func toJson() -> Dictionary<String, Any?> {
        return [
            "appId": appId,
            "appSecret": appSecret,
            "customerId": customerId,
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
    /// 商户名称
    public var merchantName: String = ""
    /// 两位国家码 CN, HK, US ...
    public var countryCode: String = ""
    
    public init(merchantIdentifier: String, merchantName: String, countryCode: String) {
        self.merchantIdentifier = merchantIdentifier
        self.merchantName = merchantName
        self.countryCode = countryCode
    }
    
    public static func from(json: NSDictionary?) -> Self {
        return ApplePayConfig(
            merchantIdentifier: json?["merchantIdentifier"] as? String ?? "",
            merchantName: json?["merchantName"] as? String ?? "",
            countryCode: json?["countryCode"] as? String ?? ""
        ) as! Self
    }
    
    public func toJson() -> Dictionary<String, Any?> {
        return [
            "merchantIdentifier": merchantIdentifier,
            "merchantName": merchantName,
            "countryCode": countryCode,
        ]
    }
}
