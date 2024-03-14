import SVGKit
import QMUIKit

class PaymentsView : UIView {
    var selectMode = false
    lazy var titleBar = initTitleBar()
    lazy var scrollView = ScrollView()
    lazy var amountLabel = UILabel()
    lazy var bankCardView = BankCardView()
    lazy var methodView = MethodView(selectMode: selectMode)
    lazy var banner = Banner()
    lazy var pendingView = PendingView()
    lazy var errorView = ErrorView()
    lazy var successfulView = SuccessfulView()
    
    var showAddCard = false {
        didSet{
            bankCardView.isHidden = !showAddCard
            methodView.isHidden = showAddCard
            if (!showAddCard) {
                bankCardView.reset()
            }
        }
    }
    
    init(selectMode: Bool = false) {
        super.init(frame: .zero)
        self.selectMode = selectMode
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUIStatus(_ status: PaymentStatus) {
        banner.isHidden = status != .normal
        pendingView.isHidden = status != .pending
        errorView.isHidden = status != .error
        successfulView.isHidden = status != .success
    }
    
    private func initView() {
        self.backgroundColor = WonderPayment.uiConfig.background
        addSubview(titleBar)
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints({ make in
            make.top.equalTo(titleBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        })
        
        let contentLayout = TGLinearLayout(.vert)
        contentLayout.tg_padding = UIEdgeInsets(top: 30, left: 24, bottom: 16, right: 24)
        contentLayout.tg_width.equal(.fill)
        contentLayout.tg_height.equal(.wrap)
        scrollView.addSubview(contentLayout)
        
        let headerView = initHeaderView()
        contentLayout.addSubview(headerView)
        
        let paymentMethodHeader = UILabel()
        paymentMethodHeader.text = "selectPaymentMethod".i18n
        paymentMethodHeader.font = UIFont(name: "Futura-Medium", size: 16)
        paymentMethodHeader.textColor = WonderPayment.uiConfig.primaryTextColor
        paymentMethodHeader.tg_width.equal(.fill)
        paymentMethodHeader.tg_height.equal(.wrap)
        paymentMethodHeader.tg_top.equal(16)
        contentLayout.addSubview(paymentMethodHeader)
        
        let paymentMethodLayout = TGLinearLayout(.vert)
        paymentMethodLayout.tg_top.equal(10)
        paymentMethodLayout.tg_vspace = 16
        paymentMethodLayout.tg_width.equal(.fill)
        paymentMethodLayout.tg_height.equal(.wrap)
        contentLayout.addSubview(paymentMethodLayout)
        
        bankCardView.isHidden = true
        paymentMethodLayout.addSubview(bankCardView)
        paymentMethodLayout.addSubview(methodView)
        
        let poweredLabel = UILabel()
        poweredLabel.font =  UIFont(name: "Futura-Medium", size: 12)
        poweredLabel.text = "Powered by Wonder"
        poweredLabel.textColor = WonderPayment.uiConfig.primaryTextColor
        poweredLabel.tg_width.equal(.wrap)
        poweredLabel.tg_height.equal(.wrap)
        poweredLabel.tg_centerX.equal(0)
        paymentMethodLayout.addSubview(poweredLabel)
        
    }
    
    private func initTitleBar() -> TitleBar{
        let titleBar = TitleBar()
        titleBar.backgroundColor = WonderPayment.uiConfig.background
        titleBar.centerView.setTitle("paymentMethod".i18n, for: .normal)
        titleBar.centerView.setTitleColor(WonderPayment.uiConfig.primaryTextColor, for: .normal)
        titleBar.centerView.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        titleBar.rightView.setImage("close".svg, for: .normal)
        
        return titleBar
    }
    
    private func initHeaderView() -> UIView {
        let headerView = TGLinearLayout(.vert)
        headerView.tg_width.equal(.fill)
        headerView.tg_height.equal(.wrap)
        
        let poweredView = TGLinearLayout(.horz)
        poweredView.backgroundColor = WonderPayment.uiConfig.secondaryButtonBackground
        poweredView.layer.cornerRadius = 8
        poweredView.tg_height.equal(34)
        poweredView.tg_width.equal(.wrap)
        poweredView.tg_padding = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        
        let poweredLabel = UILabel()
        poweredLabel.font =  UIFont(name: "Futura-Medium", size: 14)
        poweredLabel.text = "Powered by Wonder"
        poweredLabel.textColor = WonderPayment.uiConfig.secondaryButtonColor
        poweredLabel.tg_width.equal(.wrap)
        poweredLabel.tg_height.equal(.wrap)
        poweredLabel.tg_centerY.equal(0)
        poweredView.addSubview(poweredLabel)
        
        headerView.addSubview(poweredView)
        
        let totalLabel = UILabel()
        totalLabel.text = "totalAmount".i18n
        totalLabel.font = UIFont(name: "Futura-Medium", size: 16)
        totalLabel.textColor = WonderPayment.uiConfig.secondaryTextColor
        totalLabel.tg_width.equal(.wrap)
        totalLabel.tg_height.equal(.wrap)
        totalLabel.tg_top.equal(12)
        headerView.addSubview(totalLabel)
        
        amountLabel.text = "HK$0.00"
        amountLabel.font = UIFont(name: "Futura-Bold", size: 28)
        amountLabel.textColor = WonderPayment.uiConfig.primaryTextColor
        amountLabel.tg_width.equal(.wrap)
        amountLabel.tg_height.equal(.wrap)
        amountLabel.tg_top.equal(8)
        headerView.addSubview(amountLabel)
        
        let securedLayout = TGLinearLayout(.horz)
        securedLayout.tg_width.equal(.wrap)
        securedLayout.tg_height.equal(.wrap)
        securedLayout.tg_top.equal(12)
        headerView.addSubview(securedLayout)
        
        let securedIcon = UIImageView(image: "Secured".svg)
        securedIcon.tg_width.equal(.wrap)
        securedIcon.tg_height.equal(.wrap)
        securedLayout.addSubview(securedIcon)
        
        let securedLabel = UILabel()
        securedLabel.text = "securedCheckout".i18n
        securedLabel.font = UIFont(name: "Futura-Medium", size: 16)
        securedLabel.textColor = WonderPayment.uiConfig.secondaryTextColor
        securedLabel.tg_left.equal(4)
        securedLabel.tg_width.equal(.wrap)
        securedLabel.tg_height.equal(.wrap)
        securedLayout.addSubview(securedLabel)
        
        let divider = UIView()
        divider.backgroundColor = .black.withAlphaComponent(0.2)
        divider.tg_top.equal(16)
        divider.tg_width.equal(.fill)
        divider.tg_height.equal(QMUIHelper.pixelOne)
        headerView.addSubview(divider)
        
        banner.tg_top.equal(16)
        banner.tg_width.equal(.fill)
        banner.tg_height.equal(150)
        headerView.addSubview(banner)
        
        pendingView.tg_top.equal(16)
        pendingView.tg_width.equal(.fill)
        pendingView.tg_height.equal(.wrap)
        headerView.addSubview(pendingView)
        
        errorView.tg_top.equal(16)
        errorView.tg_width.equal(.fill)
        errorView.tg_height.equal(.wrap)
        headerView.addSubview(errorView)
        
        successfulView.tg_top.equal(16)
        successfulView.tg_width.equal(.fill)
        successfulView.tg_height.equal(.wrap)
        headerView.addSubview(successfulView)
        
        return headerView
    }
    
    
}
