public class UIConfig : JSONDecodable, JSONEncodable {
    public var background: UIColor
    public var secondaryBackground: UIColor
    public var primaryTextColor: UIColor
    public var secondaryTextColor: UIColor
    public var secondaryButtonColor: UIColor
    public var secondaryButtonBackground: UIColor
    public var primaryButtonColor: UIColor
    public var primaryButtonBackground: UIColor
    public var textFieldBackground: UIColor
    public var linkColor: UIColor
    public var errorColor: UIColor
    public var successColor: UIColor
    public var borderColor: UIColor
    public var borderRadius: CGFloat
    public var dividerColor: UIColor
    /// 展示风格
    public var displayStyle: DisplayStyle
    /// 是否在SDK内展示支付结果
    public var showResult: Bool
    /// 支付失败时是否允许重试
    public var paymentRetriesEnabled: Bool
    
    
    
    public init(
        background: UIColor = .white,
        secondaryBackground: UIColor = UIColor(hexString: "#FFF7F8F9"),
        primaryTextColor: UIColor = .black,
        secondaryTextColor: UIColor = UIColor(hexString: "#FF8E8E93"),
        secondaryButtonColor: UIColor = .black,
        secondaryButtonBackground: UIColor = .white,
        primaryButtonColor: UIColor = .white,
        primaryButtonBackground: UIColor = .black,
        textFieldBackground: UIColor = UIColor(hexString: "#FFF5F5F5"),
        linkColor: UIColor = UIColor(hexString: "#FF0094FF"),
        errorColor: UIColor = UIColor(hexString: "#FFFC2E01"),
        successColor: UIColor = UIColor(hexString: "#FF4CD964"),
        borderColor: UIColor = UIColor(hexString: "#FF565656"),
        borderRadius: CGFloat = 12,
        dividerColor: UIColor = UIColor(hexString: "#FFEBEFF2"),
        displayStyle: DisplayStyle = .oneClick,
        showResult: Bool = true,
        paymentRetriesEnabled: Bool = true
    ) {
        self.background = background
        self.secondaryBackground = secondaryBackground
        self.primaryTextColor = primaryTextColor
        self.secondaryTextColor = secondaryTextColor
        self.secondaryButtonColor = secondaryButtonColor
        self.secondaryButtonBackground = secondaryButtonBackground
        self.primaryButtonColor = primaryButtonColor
        self.primaryButtonBackground = primaryButtonBackground
        self.textFieldBackground = textFieldBackground
        self.linkColor = linkColor
        self.errorColor = errorColor
        self.successColor = successColor
        self.borderColor = borderColor
        self.borderRadius = borderRadius
        self.dividerColor = dividerColor
        self.displayStyle = displayStyle
        self.showResult = showResult
        self.paymentRetriesEnabled = paymentRetriesEnabled
    }
    
    public static func from(json: NSDictionary?) -> Self {
        let config = UIConfig()
        setColor(&config.background, value: json?["background"])
        setColor(&config.secondaryBackground, value: json?["secondaryBackground"])
        setColor(&config.primaryTextColor, value: json?["primaryTextColor"])
        setColor(&config.secondaryTextColor, value: json?["secondaryTextColor"])
        setColor(&config.secondaryButtonColor, value: json?["secondaryButtonColor"])
        setColor(&config.secondaryButtonBackground, value: json?["secondaryButtonBackground"])
        setColor(&config.primaryButtonColor, value: json?["primaryButtonColor"])
        setColor(&config.primaryButtonBackground, value: json?["primaryButtonBackground"])
        setColor(&config.textFieldBackground, value: json?["textFieldBackground"])
        setColor(&config.linkColor, value: json?["linkColor"])
        setColor(&config.errorColor, value: json?["errorColor"])
        setColor(&config.successColor, value: json?["successColor"])
        setColor(&config.borderColor, value: json?["borderColor"])
        setColor(&config.dividerColor, value: json?["dividerColor"])
        if let borderRadiusValue = json?["borderRadius"] as? CGFloat {
            config.borderRadius = borderRadiusValue
        }
        if let displayStyleValue = json?["displayStyle"] as? String {
            config.displayStyle = DisplayStyle(rawValue: displayStyleValue) ?? .oneClick
        }
        if let showResultValue = json?["showResult"] as? Bool {
            config.showResult = showResultValue
        }
        if let paymentRetriesEnabled = json?["paymentRetriesEnabled"] as? Bool {
            config.paymentRetriesEnabled = paymentRetriesEnabled
        }
        return config as! Self
    }
    
    private static func setColor(_ property:inout UIColor, value: Any?) {
        if let hexString = value as? String {
            property = UIColor(hexString: hexString)
        }
    }
    
    public func toJson() -> Dictionary<String, Any?> {
        return [
            "background": background.hexString,
            "secondaryBackground": secondaryBackground.hexString,
            "primaryTextColor": primaryTextColor.hexString,
            "secondaryTextColor": secondaryTextColor.hexString,
            "secondaryButtonColor": secondaryButtonColor.hexString,
            "secondaryButtonBackground": secondaryButtonBackground.hexString,
            "primaryButtonColor": primaryButtonColor.hexString,
            "primaryButtonBackground": primaryButtonBackground.hexString,
            "textFieldBackground": textFieldBackground.hexString,
            "linkColor": linkColor.hexString,
            "errorColor": errorColor.hexString,
            "successColor": successColor.hexString,
            "borderColor": borderColor.hexString,
            "borderRadius": borderRadius,
            "dividerColor": dividerColor.hexString,
            "displayStyle": displayStyle.rawValue,
            "showResult": showResult,
            "paymentRetriesEnabled": paymentRetriesEnabled,
        ]
    }
}

public enum UIMode {
    case normal, dark, auto
}

public enum DisplayStyle: String {
    //一键，二次确认
    case oneClick,confirm
}
