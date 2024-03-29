import SVGKit
import QMUIKit
import TangramKit

class PaymentsView : TGLinearLayout {
    var displayStyle: DisplayStyle = .oneClick
    var sessionMode: SessionMode = .once
    lazy var titleBar = initTitleBar()
    lazy var scrollView = ScrollView()
    lazy var amountLabel = UILabel()
    lazy var bankCardView = BankCardView(addMode: sessionMode == .twice)
    lazy var methodView = MethodView(displayStyle: displayStyle)
    lazy var banner = Banner()
    lazy var paymentMethodLayout = TGLinearLayout(.vert)
    lazy var pendingView = PendingView()
    lazy var errorView = ErrorView()
    lazy var successfulView = SuccessfulView()
    lazy var selectConfirmButton = Button(title: "confirm".i18n, style: .secondary)
    
    var onMethodConfirm: SelectMethodCallback?
    
    var showAddCard = false {
        didSet{
            bankCardView.isHidden = !showAddCard
            methodView.isHidden = showAddCard
            selectConfirmButton.isHidden = showAddCard || displayStyle == .oneClick
            if (!showAddCard) {
                bankCardView.reset()
            }
        }
    }
    
    init(displayStyle: DisplayStyle = .oneClick, sessionMode: SessionMode = .once) {
        super.init(frame: .zero, orientation: .vert)
        self.displayStyle = displayStyle
        self.sessionMode = sessionMode
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
        paymentMethodLayout.isHidden = status == .success
        selectConfirmButton.isHidden = status == .success || displayStyle != .confirm
    }
    
    private func initView() {
        self.backgroundColor = WonderPayment.uiConfig.background
        self.tg_height.equal(.fill)
        self.tg_width.equal(.fill)
        addSubview(titleBar)
        
        scrollView.alwaysBounceVertical = true
        scrollView.tg_width.equal(.fill)
        scrollView.tg_height.equal(.fill)
        addSubview(scrollView)
        
        let contentLayout = TGLinearLayout(.vert)
        contentLayout.tg_padding = UIEdgeInsets(top: 30, left: 24, bottom: 16, right: 24)
        contentLayout.tg_width.equal(.fill)
        contentLayout.tg_height.equal(.wrap)
        scrollView.addSubview(contentLayout)
        
        let headerView = initHeaderView()
        contentLayout.addSubview(headerView)
        
        paymentMethodLayout.tg_top.equal(10)
        paymentMethodLayout.tg_vspace = 16
        paymentMethodLayout.tg_width.equal(.fill)
        paymentMethodLayout.tg_height.equal(.wrap)
        contentLayout.addSubview(paymentMethodLayout)
        
        let paymentMethodHeader = UILabel()
        paymentMethodHeader.text = "selectPaymentMethod".i18n
        paymentMethodHeader.font = UIFont(name: "Futura-Medium", size: 16)
        paymentMethodHeader.textColor = WonderPayment.uiConfig.primaryTextColor
        paymentMethodHeader.tg_width.equal(.fill)
        paymentMethodHeader.tg_height.equal(.wrap)
        paymentMethodHeader.tg_top.equal(16)
        paymentMethodLayout.addSubview(paymentMethodHeader)
        
        bankCardView.isHidden = true
        methodView.delegate = self
        paymentMethodLayout.addSubview(bankCardView)
        paymentMethodLayout.addSubview(methodView)
        
        let poweredLabel = UILabel()
        poweredLabel.font =  UIFont(name: "Futura-Medium", size: 12)
        poweredLabel.text = "Powered by Wonder.app"
        poweredLabel.textColor = WonderPayment.uiConfig.primaryTextColor
        poweredLabel.tg_width.equal(.wrap)
        poweredLabel.tg_height.equal(.wrap)
        poweredLabel.tg_centerX.equal(0)
        poweredLabel.tg_top.equal(16)
        contentLayout.addSubview(poweredLabel)
        
        let confirmLayout = TGLinearLayout(.vert)
        confirmLayout.backgroundColor = WonderPayment.uiConfig.secondaryBackground
        confirmLayout.tg_width.equal(.fill)
        confirmLayout.tg_height.equal(.wrap)
        addSubview(confirmLayout)
        
        selectConfirmButton.isHidden = displayStyle != .confirm
        selectConfirmButton.isEnabled = false
        selectConfirmButton.tg_horzMargin(16)
        selectConfirmButton.tg_top.equal(16)
        selectConfirmButton.tg_bottom.equal(QMUIHelper.safeAreaInsetsForDeviceWithNotch.bottom + 16)
        selectConfirmButton.addTarget(self, action: #selector(onConfirm(_:)), for: .touchUpInside)
        confirmLayout.addSubview(selectConfirmButton)
    }
    
    @objc private func onConfirm(_ sender: Any) {
        let method = methodView.selectedMethod
        onMethodConfirm?(method!)
    }
    
    private func initTitleBar() -> TitleBar{
        let titleBar = TitleBar()
        titleBar.backgroundColor = WonderPayment.uiConfig.background
        titleBar.titleLabel.text = "paymentMethod".i18n
        titleBar.titleLabel.textColor = WonderPayment.uiConfig.primaryTextColor
        titleBar.titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleBar.rightView.setImage("close".svg, for: .normal)
        
        return titleBar
    }
    
    private func initHeaderView() -> UIView {
        let headerView = TGLinearLayout(.vert)
        headerView.tg_width.equal(.fill)
        headerView.tg_height.equal(.wrap)
        
//        let poweredView = TGLinearLayout(.horz)
//        poweredView.backgroundColor = WonderPayment.uiConfig.secondaryButtonBackground
//        poweredView.layer.cornerRadius = 8
//        poweredView.tg_height.equal(34)
//        poweredView.tg_width.equal(.wrap)
//        poweredView.tg_padding = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
//        
//        let poweredLabel = UILabel()
//        poweredLabel.font =  UIFont(name: "Futura-Medium", size: 14)
//        poweredLabel.text = "Powered by Wonder"
//        poweredLabel.textColor = WonderPayment.uiConfig.secondaryButtonColor
//        poweredLabel.tg_width.equal(.wrap)
//        poweredLabel.tg_height.equal(.wrap)
//        poweredLabel.tg_centerY.equal(0)
//        poweredView.addSubview(poweredLabel)
//        
//        headerView.addSubview(poweredView)
        
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

extension PaymentsView: MethodViewDelegate {
    func onSelectedChange(selected: PaymentMethod?) {
        selectConfirmButton.isEnabled = selected != nil
    }
    
    func onSelectedConfirm(selected: PaymentMethod) {
        onMethodConfirm?(selected)
    }
}
