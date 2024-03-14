
class SuccessfulView : TGLinearLayout {
    convenience init() {
        self.init(frame: .zero, orientation: .vert)
        self.initView()
    }
    
    private func initView() {
        self.tg_vspace = 16
        let layout1 = TGLinearLayout(.vert)
        layout1.tg_width.equal(.fill)
        layout1.tg_height.equal(.wrap)
        layout1.tg_padding = UIEdgeInsets.all(16)
        layout1.layer.borderColor = WonderPayment.uiConfig.primaryButtonColor.cgColor
        layout1.layer.borderWidth = 1
        layout1.layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        addSubview(layout1)
        
        let icon = UIImageView(image: "successful".svg)
        icon.tg_centerX.equal(0)
        layout1.addSubview(icon)
        
        let titleLabel = Label("successfulPayment".i18n,size: 18, fontStyle: .medium)
        titleLabel.tg_centerX.equal(0)
        titleLabel.tg_top.equal(8)
        layout1.addSubview(titleLabel)
        
        let amountLabel = Label("HK$0.00",size: 28, fontStyle: .bold)
        amountLabel.tg_width.equal(.fill)
        amountLabel.tg_top.equal(16)
        amountLabel.textAlignment = .center
        layout1.addSubview(amountLabel)
        
//        let layout2 = TGLinearLayout(.vert)
//        layout2.tg_width.equal(.fill)
//        layout2.tg_height.equal(.wrap)
//        layout2.tg_padding = UIEdgeInsets.all(16)
//        layout2.layer.borderColor = WonderPayment.uiConfig.primaryButtonColor.cgColor
//        layout2.layer.borderWidth = 1
//        layout2.layer.cornerRadius = 12
//        addSubview(layout2)
        
    }
}
