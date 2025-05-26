import SVGKit

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
    lazy var placeholderLayout = TGLinearLayout(.vert)
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
        
        placeholderLayout.tg_width.equal(.fill)
        placeholderLayout.tg_height.equal(.wrap)
        paymentMethodLayout.addSubview(placeholderLayout)
        
        for i in 0...3 {
            let placeholderView = PlaceholderView()
            placeholderView.tg_height.equal(i == 0 ? 114 : 58)
            placeholderView.tg_width.equal(.fill)
            placeholderLayout.tg_vspace = 16
            placeholderLayout.addSubview(placeholderView)
        }
        
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
        selectConfirmButton.tg_bottom.equal(safeInsets.bottom + 16)
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
            "close".svg?.withTintColor(WonderPayment.uiConfig.primaryButtonBackground),
            for: .normal
        )
        
        return titleBar
    }
    
    private func initAmountView() -> UIView {
        let amountView = TGLinearLayout(.vert)
        amountView.tg_width.equal(.fill)
        amountView.tg_height.equal(.wrap)
        
        if transactionType == .preAuth {
            let preAuthButton = Button()
            preAuthButton.setTitle("ⓘ \("thisIsPreAuth".i18n)", for: .normal)
            preAuthButton.setTitleColor(WonderPayment.uiConfig.linkColor, for: .normal)
            preAuthButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            preAuthButton.tg_width.equal(.wrap)
            preAuthButton.tg_height.equal(.wrap)
            preAuthButton.tg_bottom.equal(12)
            preAuthButton.addTarget(self, action: #selector(showPreAuthDesc), for: .touchUpInside)
            amountView.addSubview(preAuthButton)
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
        divider.backgroundColor = WonderPayment.uiConfig.dividerColor
        divider.tg_top.equal(16)
        divider.tg_width.equal(.fill)
        divider.tg_height.equal(1 )
        amountView.addSubview(divider)
        
        return amountView
    }
    
    func setSelectedMethod(_ method: PaymentMethod) {
        methodView.setSelectedMethod(method)
        let targetView: UIView?
        let canSelect: Bool
        if method.type == .creditCard {
            targetView = methodView.cardItemsLayout
            canSelect = true
        } else {
            let itemView = methodView.findMethodItemView(by: method)
            targetView = itemView
            canSelect = itemView?.canSelect ?? false
        }
        if let targetView, canSelect {
            // 1. 将 targetView 的 bounds 转换到 scrollView 的坐标系
            var targetRect = targetView.convert(targetView.bounds, to: scrollView)
            
            // 2. 获取 scrollView 所在控制器的 safe area bottom inset
            let safeBottomInset = scrollView.safeAreaInsets.bottom
            
            // 3. 人为扩大 targetRect 的高度以避免贴在底部
            targetRect.size.height += safeBottomInset + 20
            scrollView.scrollRectToVisible(targetRect, animated: true)
        }
    }
    
    @objc private func showPreAuthDesc() {
        let dialog = PreAuthDescDialog()
        dialog.show()
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
