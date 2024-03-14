
class CheckBox : UIButton {

    var onChange: ((Bool) -> Void)?
    
    convenience init() {
        self.init(frame: .zero)
        self.initView()
    }
    
    private func initView() {
        setImage("unchecked".svg, for: .normal)
        setImage("selected".svg, for: .selected)
        addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
    }
    
    @objc func onClick(_ sender: UIButton) {
        isSelected = !isSelected
        onChange?(isSelected)
    }
}
