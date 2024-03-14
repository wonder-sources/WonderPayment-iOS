
class RadioButton : UIButton {

    enum Style {
        case radio, check
    }
    
    var style: Style = .radio
    var cancellable: Bool = false
    
    convenience init(style: Style = .radio, cancellable: Bool = false) {
        self.init(frame: .zero)
        self.style = style
        self.cancellable = cancellable
        self.initView()
    }
    
    private func initView() {
        setImage("unchecked".svg, for: .normal)
        switch style {
        case .radio:
            setImage("checked".svg, for: .selected)
        case .check:
            setImage("selected".svg, for: .selected)
        }
        addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
    }
    
    @objc func onClick(_ sender: UIButton) {
        if cancellable {
            isSelected = !isSelected
        } else {
            isSelected = true
        }
    }
}
