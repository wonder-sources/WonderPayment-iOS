public class UIConfig {
    
    public var background: UIColor = .white
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
    public var creditCardTop: Bool = false
    
    
    public var mode: UIMode = .auto
}

public enum UIMode {
    case normal, dark, auto
}
