
public class PaymentConfig {
    public var businessId: String = ""
    public var source: String = ""
    public var token: String = ""
    public var scheme: String = ""
    public var environment: PaymentEnvironment = .production
    public var locale: Locale = .zh_HK
    public var wechat: WechatConfig?
    public var applePay: ApplePayConfig?
}

/// 相关配置参考 https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/iOS.html
public class WechatConfig {
    public var appId: String = ""
    public var universalLink: String = ""
    
    public init(appId: String, universalLink: String) {
        self.appId = appId
        self.universalLink = universalLink
    }
}

public class ApplePayConfig {
    /// Apple Developer 后台申请的商户ID
    public var merchantIdentifier: String = ""
    /// 两位国家码 CN, HK, US ...
    public var countryCode: String = ""
    
    public init(merchantIdentifier: String, countryCode: String) {
        self.merchantIdentifier = merchantIdentifier
        self.countryCode = countryCode
    }
}
