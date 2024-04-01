public class UIConfig : JSONDecodable {
    public var background: UIColor = .white
    public var secondaryBackground: UIColor = UIColor(hexString: "#FFF7F8F9")
    public var primaryTextColor: UIColor = .black
    public var secondaryTextColor: UIColor = UIColor(hexString: "#FF8E8E93")
    public var secondaryButtonColor: UIColor = .black
    public var secondaryButtonBackground: UIColor = .white
    public var primaryButtonColor: UIColor = .white
    public var primaryButtonBackground: UIColor = .black
    public var primaryButtonDisableBackground: UIColor = UIColor(hexString: "#FF8E8E93")
    public var textFieldBackground: UIColor = UIColor(hexString: "#FFF5F5F5")
    public var linkColor: UIColor = UIColor(hexString: "#FF0094FF")
    public var errorColor: UIColor = UIColor(hexString: "#FFFC2E01")
    public var borderRadius: CGFloat = 12
    /// 展示风格
    public var displayStyle: DisplayStyle = .oneClick
    /// 是否在SDK内展示支付结果
    public var showResult: Bool = true
    
    
    //public var mode: UIMode = .auto
    
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
        setColor(&config.primaryButtonDisableBackground, value: json?["primaryButtonDisableBackground"])
        setColor(&config.textFieldBackground, value: json?["textFieldBackground"])
        setColor(&config.linkColor, value: json?["linkColor"])
        setColor(&config.errorColor, value: json?["errorColor"])
        if let borderRadiusValue = json?["borderRadius"] as? CGFloat {
            config.borderRadius = borderRadiusValue
        }
        if let displayStyleValue = json?["displayStyle"] as? String {
            config.displayStyle = DisplayStyle(rawValue: displayStyleValue) ?? .oneClick
        }
        if let showResultValue = json?["showResult"] as? Bool {
            config.showResult = showResultValue
        }
        return config as! Self
    }
    
    private static func setColor(_ property:inout UIColor, value: Any?) {
        if let hexString = value as? String {
            property = UIColor(hexString: hexString)
        }
    }
}

public enum UIMode {
    case normal, dark, auto
}

public enum DisplayStyle: String {
    //一键，二次确认
    case oneClick,confirm
}
