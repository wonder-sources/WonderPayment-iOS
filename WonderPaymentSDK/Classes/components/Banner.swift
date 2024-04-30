import TangramKit

class Banner : TGFrameLayout {
    
//    let backgroundLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initView() {
        self.tg_width.equal(.fill)
        self.tg_height.equal(.wrap)
        
        let imageView = SvgImageView(named: "ad_bg")
        imageView.tg_width.equal(.fill)
        imageView.tg_height.equal(.wrap)
        addSubview(imageView)
        
        let centerLayout = TGLinearLayout(.vert)
        centerLayout.tg_width.equal(.fill)
        centerLayout.tg_height.equal(.wrap)
        centerLayout.tg_centerY.equal(0)
        centerLayout.tg_left.equal(20)
        centerLayout.tg_right.equal(20)
        addSubview(centerLayout)
        
        let label1 = UILabel()
        label1.text = "streetHailPay".i18n
        label1.font = UIFont(name: "Helvetica-Bold", size: 14)
        label1.textColor = UIColor(hexString: "#FF523535")
        label1.tg_width.equal(.fill)
        label1.tg_height.equal(.wrap)
        centerLayout.addSubview(label1)
        
        let label2 = UILabel()
        let text = "serviceFee".i18n
        let range = (text as NSString).range(of: "$0")
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor(hexString: "#FF523535"), range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        label2.attributedText = attributedString
        label2.font = UIFont(name: "Helvetica-Bold", size: 24)
        label2.tg_top.equal(4)
        label2.tg_width.equal(.fill)
        label2.tg_height.equal(.wrap)
        centerLayout.addSubview(label2)
    }
    
}
