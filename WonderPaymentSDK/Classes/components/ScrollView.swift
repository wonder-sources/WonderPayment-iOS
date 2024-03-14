
class ScrollView : UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        delaysContentTouches = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        return true
    }
    
}
