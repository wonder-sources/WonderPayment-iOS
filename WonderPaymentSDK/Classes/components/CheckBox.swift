
class CheckBox : UIButton {

    var onChange: ((Bool) -> Void)?
    
    override var isSelected: Bool {
        didSet {
            setBackground()
        }
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.initView()
    }
    
    private func initView() {
        let tintColor = WonderPayment.uiConfig.primaryButtonColor
        let borderColor = WonderPayment.uiConfig.primaryButtonBackground
        self.layer.cornerRadius = 12
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 2
        setImage("selected".svg?.withTintColor(tintColor), for: .selected)
        addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
    }
    
    private func setBackground() {
        let backgroundColor: UIColor?
        if isSelected {
            backgroundColor = WonderPayment.uiConfig.primaryButtonBackground
        } else {
            backgroundColor = nil
        }
        self.backgroundColor = backgroundColor
    }
    
    @objc func onClick(_ sender: UIButton) {
        isSelected = !isSelected
        onChange?(isSelected)
    }
}
