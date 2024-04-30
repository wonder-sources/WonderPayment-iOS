import SVGKit
import QMUIKit
import TangramKit

class PaymentsView : TGLinearLayout {
    var displayStyle: DisplayStyle
    var sessionMode: SessionMode
    var previewMode: Bool
    var transactionType: TransactionType
    lazy var titleBar = initTitleBar()
    lazy var scrollView = ScrollView()
    lazy var amountLabel = UILabel()
    lazy var bankCardView = BankCardView(addMode: sessionMode == .twice || previewMode)
    lazy var methodView = MethodView(displayStyle: displayStyle, previewMode: previewMode)
    lazy var banner = Banner()
    lazy var paymentMethodLayout = TGLinearLayout(.vert)
    lazy var pendingView = PendingView()
    lazy var errorView = ErrorView()
    lazy var successfulView = SuccessfulView()
    lazy var selectConfirmButton = Button(title: "confirm".i18n, style: .primary)
    
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
    
    init(displayStyle: DisplayStyle = .oneClick, sessionMode: SessionMode = .once, previewMode: Bool = false, transactionType: TransactionType = .sale) {
        self.displayStyle = displayStyle
        self.sessionMode = sessionMode
        self.previewMode = previewMode
        self.transactionType = transactionType
        super.init(frame: .zero, orientation: .vert)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        scrollView.showsVerticalScrollIndicator = false
        scrollView.tg_width.equal(.fill)
        scrollView.tg_height.equal(.fill)
        addSubview(scrollView)
        
        let contentLayout = TGLinearLayout(.vert)
        contentLayout.tg_padding = UIEdgeInsets(top: 30, left: 24, bottom: 16, right: 24)
        contentLayout.tg_width.equal(.fill)
        contentLayout.tg_height.equal(.wrap)
        scrollView.addSubview(contentLayout)
        
        if !(previewMode || sessionMode == .twice) {
            let amountView = initAmountView()
            amountView.tg_bottom.equal(16)
            contentLayout.addSubview(amountView)
        }
        
        banner.tg_width.equal(.fill)
        banner.tg_height.equal(.wrap)
        contentLayout.addSubview(banner)
        
        pendingView.tg_top.equal(16)
        pendingView.tg_width.equal(.fill)
        pendingView.tg_height.equal(.wrap)
        contentLayout.addSubview(pendingView)
        
        errorView.tg_top.equal(16)
        errorView.tg_width.equal(.fill)
        errorView.tg_height.equal(.wrap)
        contentLayout.addSubview(errorView)
        
        successfulView.tg_top.equal(16)
        successfulView.tg_width.equal(.fill)
        successfulView.tg_height.equal(.wrap)
        contentLayout.addSubview(successfulView)
        
        paymentMethodLayout.tg_top.equal(16)
        paymentMethodLayout.tg_vspace = 16
        paymentMethodLayout.tg_width.equal(.fill)
        paymentMethodLayout.tg_height.equal(.wrap)
        contentLayout.addSubview(paymentMethodLayout)
        
        var title = "selectPaymentMethod".i18n
        if previewMode {
            title = "availablePaymentMethod".i18n
        } else if (transactionType == .preAuth) {
            title = "preAuthPaymentMethod".i18n
        }
        let paymentMethodHeader = Label(title, size: 16, fontStyle: .medium)
        paymentMethodHeader.textColor = WonderPayment.uiConfig.primaryTextColor
        paymentMethodHeader.tg_width.equal(.fill)
        paymentMethodHeader.tg_height.equal(.wrap)
        paymentMethodLayout.addSubview(paymentMethodHeader)
        
        bankCardView.isHidden = true
        methodView.delegate = self
        paymentMethodLayout.addSubview(bankCardView)
        paymentMethodLayout.addSubview(methodView)
        
        let poweredLabel = Label("Powered by Wonder.app", size: 12, fontStyle: .medium)
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
        titleBar.rightView.setImage(
            "close".svg?.qmui_image(withTintColor: WonderPayment.uiConfig.primaryTextColor),
            for: .normal
        )
        
        return titleBar
    }
    
    private func initAmountView() -> UIView {
        let amountView = TGLinearLayout(.vert)
        amountView.tg_width.equal(.fill)
        amountView.tg_height.equal(.wrap)
        
        if transactionType == .preAuth {
            let preAuthLabel = Label("thisIsPreAuth".i18n, size: 16, fontStyle: .medium)
            preAuthLabel.textColor = WonderPayment.uiConfig.linkColor
            preAuthLabel.tg_width.equal(.fill)
            preAuthLabel.tg_height.equal(.wrap)
            preAuthLabel.tg_bottom.equal(12)
            amountView.addSubview(preAuthLabel)
        }
        
        let totalLabel = Label("totalAmount".i18n, size: 16, fontStyle: .medium)
        totalLabel.textColor = WonderPayment.uiConfig.secondaryTextColor
        totalLabel.tg_width.equal(.wrap)
        totalLabel.tg_height.equal(.wrap)
        amountView.addSubview(totalLabel)
        
        amountLabel.text = "HK$0.00"
        amountLabel.font = UIFont(name: "Outfit-SemiBold", size: 28)
        amountLabel.textColor = WonderPayment.uiConfig.primaryTextColor
        amountLabel.tg_width.equal(.wrap)
        amountLabel.tg_height.equal(.wrap)
        amountLabel.tg_top.equal(8)
        amountView.addSubview(amountLabel)
        
        let securedLayout = TGLinearLayout(.horz)
        securedLayout.tg_width.equal(.wrap)
        securedLayout.tg_height.equal(.wrap)
        securedLayout.tg_top.equal(12)
        amountView.addSubview(securedLayout)
        
        let securedIcon = UIImageView(image: "Secured".svg)
        securedIcon.tg_width.equal(.wrap)
        securedIcon.tg_height.equal(.wrap)
        securedLayout.addSubview(securedIcon)
        
        let securedLabel = Label("securedCheckout".i18n, size: 16, fontStyle: .medium)
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
        amountView.addSubview(divider)
        
        return amountView
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
