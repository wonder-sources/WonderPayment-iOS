import TangramKit

class Banner : UIView {
    
    let backgroundLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initView() {
        backgroundLayer.cornerRadius = WonderPayment.uiConfig.borderRadius
        backgroundLayer.colors = [
            UIColor(hexString: "#EED1AF").cgColor,
            UIColor(hexString: "#FAEAD2").cgColor
        ]
        backgroundLayer.startPoint = CGPoint(x: 0, y: 0)
        backgroundLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(backgroundLayer)
        
        let layout = TGLinearLayout(.vert)
        layout.tg_width.equal(.fill)
        layout.tg_height.equal(.fill)
        layout.tg_padding = UIEdgeInsets(top: 18, left: 20, bottom: 0, right: 20)
        addSubview(layout)
        
        let label1 = UILabel()
        label1.text = "hailDiscount".i18n
        label1.font = UIFont(name: "Helvetica-Bold", size: 18)
        label1.textColor = UIColor(hexString: "#FF75604E")
        label1.tg_width.equal(.fill)
        label1.tg_height.equal(.wrap)
        layout.addSubview(label1)
        
        let label2 = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        label2.attributedText = NSAttributedString(string: "enjoyStreetHail".i18n, attributes: [.paragraphStyle: paragraphStyle])
        label2.font = UIFont(name: "Helvetica-Light", size: 14)
        label2.textColor = UIColor(hexString: "#FFA08770")
        label2.tg_top.equal(8)
        label2.tg_width.equal(.fill)
        label2.tg_height.equal(.wrap)
        layout.addSubview(label2)
        
        let label3 = UILabel()
        label3.text = "serviceFee".i18n
        label3.font = UIFont(name: "Helvetica-Bold", size: 24)
        label3.textColor = UIColor(hexString: "#FF75604E")
        label3.tg_top.equal(12)
        label3.tg_width.equal(.fill)
        label3.tg_height.equal(.wrap)
        layout.addSubview(label3)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        backgroundLayer.frame = CGRect(x: 0, y: 0 , width: frame.width, height: frame.height)
    }
}
