
public class PaymentConfig {
    public var businessId: String = ""
    public var source: String = ""
    public var token: String = ""
    public var scheme: String = ""
    public var environment: PaymentEnvironment = .production
    public var locale: Locale = .zh_HK
    public var wechat: WechatConfig = WechatConfig()
}

public class WechatConfig {
    public var appId: String = ""
    public var universalLink: String = ""
}
