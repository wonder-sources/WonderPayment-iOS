
class RadioButton : UIButton {

    enum Style {
        case radio, check
    }
    
    var style: Style = .radio
    var cancellable: Bool = false
    override var isSelected: Bool {
        didSet {
            setBackground()
        }
    }
    
    convenience init(style: Style = .radio, cancellable: Bool = false) {
        self.init(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.style = style
        self.cancellable = cancellable
        self.initView()
    }
    
    private func initView() {
        let tintColor = WonderPayment.uiConfig.primaryButtonColor
        let borderColor = WonderPayment.uiConfig.primaryButtonBackground
        self.layer.cornerRadius = 12
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 2
        
        switch style {
        case .radio:
            setImage("checked".svg?.withTintColor(borderColor), for: .selected)
        case .check:
            setImage("selected".svg?.withTintColor(tintColor), for: .selected)
        }
        addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
    }
    
    private func setBackground() {
        let backgroundColor: UIColor?
        if isSelected && style == .check {
            backgroundColor = WonderPayment.uiConfig.primaryButtonBackground
        } else {
            backgroundColor = nil
        }
        self.backgroundColor = backgroundColor
    }
    
    @objc func onClick(_ sender: UIButton) {
        if cancellable {
            isSelected = !isSelected
        } else {
            isSelected = true
        }
    }
}
