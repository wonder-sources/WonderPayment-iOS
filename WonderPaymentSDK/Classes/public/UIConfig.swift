public class UIConfig {
    
    public var background: UIColor = .white
    public var secondaryBackground: UIColor = UIColor(hexString: "#FFF7F8F9")
    public var primaryTextColor: UIColor = .black
    public var secondaryTextColor: UIColor = UIColor(hexString: "#FF8E8E93")
    public var primaryButtonColor: UIColor = .black
    public var primaryButtonBackground: UIColor = .white
    public var secondaryButtonColor: UIColor = .white
    public var secondaryButtonBackground: UIColor = .black
    public var secondaryButtonDisableBackground: UIColor = UIColor(hexString: "#FF8E8E93")
    public var textFieldBackground: UIColor = UIColor(hexString: "#FFF5F5F5")
    public var linkColor: UIColor = UIColor(hexString: "#FF0094FF")
    public var errorColor: UIColor = UIColor(hexString: "#FFFC2E01")
    public var borderRadius: CGFloat = 12
    /// 展示风格
    public var displayStyle: DisplayStyle = .oneClick
    /// 是否在SDK内展示支付结果
    public var showResult: Bool = true
    
    
    public var mode: UIMode = .auto
}

public enum UIMode {
    case normal, dark, auto
}

public enum DisplayStyle {
    //一键，二次确认
    case oneClick,confirm
}
