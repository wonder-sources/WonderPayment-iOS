protocol MethodItemView: AnyObject where Self: UIView {
    var canSelect: Bool { get }
    var isSelected: Bool { get set }
    var method: PaymentMethod? { get set }
}

protocol MethodViewDelegate: AnyObject {
    /// 选择改变
    func onSelectedChange(selected: PaymentMethod?)
    /// 选择确认
    func onSelectedConfirm(selected: PaymentMethod)
}

class MethodView : TGLinearLayout {
    
    var displayStyle: DisplayStyle = .oneClick
    var previewMode: Bool
    
    lazy var applePayButton = ApplePayButton(displayStyle: displayStyle, previewMode: previewMode)
    lazy var unionPayButton = MethodButton(image: "UnionPay", title: "unionPay".i18n, displayStyle: displayStyle, previewMode: previewMode)
    lazy var wechatPayButton = MethodButton(image: "WechatPay", title: "wechatPay".i18n, displayStyle: displayStyle, previewMode: previewMode)
    lazy var alipayButton = MethodButton(image: "Alipay", title: "alipay".i18n, displayStyle: displayStyle, previewMode: previewMode)
    lazy var alipayHKButton = MethodButton(image: "AlipayHK", title: "alipayHK".i18n, displayStyle: displayStyle, previewMode: previewMode)
    lazy var octopusButton = MethodButton(image: "Octopus", title: "octopus".i18n, displayStyle: displayStyle, previewMode: previewMode)
    lazy var fpsButton = MethodButton(image: "FPS", title: "fps".i18n, displayStyle: displayStyle, previewMode: previewMode)
    lazy var paymeButton = MethodButton(image: "PayMe", title: "payme".i18n, displayStyle: displayStyle, previewMode: previewMode)
    lazy var addCardButton = createAddCardButton()
    lazy var cardView = createCardView()
    lazy var cardItemsLayout = TGLinearLayout(.vert)
    lazy var cardConfirmButton = Button(title: "confirm".i18n, style: .primary)
    
    var lastSelected: MethodItemView?
    
    private(set) var selectedMethod: PaymentMethod? {
        didSet{
            cardConfirmButton.isHidden = previewMode || displayStyle == .confirm || selectedMethod?.type != .creditCard
            delegate?.onSelectedChange(selected: selectedMethod)
        }
    }
    
    weak var delegate: MethodViewDelegate?

    init(displayStyle: DisplayStyle = .oneClick, previewMode: Bool = false) {
        self.displayStyle = displayStyle
        self.previewMode = previewMode
        super.init(frame: .zero, orientation: .vert)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.tg_vspace = 16
        self.tg_width.equal(.fill)
        self.tg_height.equal(.wrap)
        
        applePayButton.method = PaymentMethod(type: .applePay)
        unionPayButton.method = PaymentMethod(type: .unionPay)
        wechatPayButton.method = PaymentMethod(type: .wechat)
        alipayButton.method = PaymentMethod(type: .alipay)
        alipayHKButton.method = PaymentMethod(type: .alipayHK)
        octopusButton.method = PaymentMethod(type: .octopus)
        fpsButton.method = PaymentMethod(type: .fps)
        paymeButton.method = PaymentMethod(type: .payme)
        
        applePayButton.addTarget(self, action: #selector(onMethodItemClick(_:)), for: .touchUpInside)
        unionPayButton.addTarget(self, action: #selector(onMethodItemClick(_:)), for: .touchUpInside)
        wechatPayButton.addTarget(self, action: #selector(onMethodItemClick(_:)), for: .touchUpInside)
        alipayButton.addTarget(self, action: #selector(onMethodItemClick(_:)), for: .touchUpInside)
        alipayHKButton.addTarget(self, action: #selector(onMethodItemClick(_:)), for: .touchUpInside)
        octopusButton.addTarget(self, action: #selector(onMethodItemClick(_:)), for: .touchUpInside)
        fpsButton.addTarget(self, action: #selector(onMethodItemClick(_:)), for: .touchUpInside)
        paymeButton.addTarget(self, action: #selector(onMethodItemClick(_:)), for: .touchUpInside)
        
        addSubview(applePayButton)
        addSubview(unionPayButton)
        addSubview(wechatPayButton)
        addSubview(alipayButton)
        addSubview(alipayHKButton)
        addSubview(octopusButton)
        addSubview(fpsButton)
        addSubview(paymeButton)
        
        
        if displayStyle == .confirm || previewMode {
            insertSubview(cardView, at: 0)
        } else {
            addSubview(cardView)
        }
        
        applePayButton.isHidden = true
        unionPayButton.isHidden = true
        wechatPayButton.isHidden = true
        alipayButton.isHidden = true
        alipayHKButton.isHidden = true
        cardView.isHidden = true
        octopusButton.isHidden = true
        fpsButton.isHidden = true
        paymeButton.isHidden = true
    }
    
    func setCardItems(_ items: [CreditCardInfo]) {
        for subview in cardItemsLayout.subviews {
            subview.removeFromSuperview()
        }
        if lastSelected?.method?.type == .creditCard {
            lastSelected = nil
        }
        if selectedMethod?.type == .creditCard {
            selectedMethod = nil
        }
        if (!items.isEmpty) {
            let divider = UIView()
            divider.backgroundColor = WonderPayment.uiConfig.dividerColor
            divider.tg_width.equal(.fill)
            divider.tg_height.equal(1)

            for index in 0..<items.count {
                let item = items[index]
                let icon = CardMap.getIcon(item.brand ?? "")
                let cardNumber = formatCardNumber(brand: item.brand ?? "", number: item.number ?? "")
//                let isSelected = item.default ?? false
                let itemView = CardItemView(icon: icon, cardNumber: cardNumber,isSelected: isSelected, displayStyle: displayStyle, previewMode: previewMode)
                itemView.method = PaymentMethod(type: .creditCard, arguments: item.toPaymentArguments())
                itemView.addGestureRecognizer(
                    UITapGestureRecognizer(
                        target: self,
                        action: #selector(onMethodItemClick(_:))
                    )
                )
//                if isSelected {
//                    selectedMethod = itemView.method
//                    lastSelected?.isSelected = false
//                    lastSelected = itemView
//                }
                cardItemsLayout.addSubview(itemView)
            }
            
            cardItemsLayout.addSubview(divider)
        }
    }
    
    func setSelectedMethod(_ method: PaymentMethod) {
        lastSelected?.isSelected = false
        let itemView = findMethodItemView(by: method)
        itemView?.isSelected = true
        selectedMethod = itemView?.method
        lastSelected = itemView
    }
    
    func findMethodItemView(by method: PaymentMethod) -> MethodItemView? {
        if method.type == .creditCard {
            let cardNumber = method.arguments?["number"] as? String
            for subview in cardItemsLayout.subviews {
                if let itemView = subview as? MethodItemView,
                   let itemNumber = itemView.method?.arguments?["number"] as? String,
                   itemNumber == cardNumber {
                    return itemView
                }
            }
        } else {
            for subview in subviews {
                if let itemView = subview as? MethodItemView, itemView.method?.type == method.type {
                    return itemView
                }
            }
        }
        return nil
    }
    
    @objc private func onMethodItemClick(_ sender: Any) {
        var itemView : MethodItemView
        if sender is UITapGestureRecognizer {
            itemView = (sender as! UITapGestureRecognizer).view as! MethodItemView
        } else {
            itemView = sender as! MethodItemView
        }
        let method = itemView.method
        if previewMode || (displayStyle == .oneClick && method?.type != .creditCard) {
            delegate?.onSelectedConfirm(selected: method!)
            return
        }
        if (!itemView.isSelected) {
            itemView.isSelected = true
            selectedMethod = itemView.method
            lastSelected?.isSelected = false
            lastSelected = itemView
        }
    }
    
    @objc private func onCardConfirm(_ sender: Any) {
        if (selectedMethod?.type == .creditCard) {
            delegate?.onSelectedConfirm(selected: selectedMethod!)
        }
    }
    
    private func createCardView() -> UIView {
        let creditCardView = TGLinearLayout(.vert)
        creditCardView.backgroundColor = WonderPayment.uiConfig.secondaryButtonBackground
        creditCardView.layer.borderWidth = 1
        creditCardView.layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        creditCardView.layer.borderColor = WonderPayment.uiConfig.borderColor.cgColor
        creditCardView.tg_width.equal(.fill)
        creditCardView.tg_height.equal(.wrap).min(56)
        creditCardView.tg_padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let createLayout = TGLinearLayout(.horz)
        createLayout.tg_width.equal(.fill)
        createLayout.tg_height.equal(56)
        creditCardView.addSubview(createLayout)
        
        let label = Label("card".i18n, size: 16, fontStyle: .medium)
        label.textColor = WonderPayment.uiConfig.secondaryButtonColor
        label.tg_width.equal(.wrap)
        label.tg_height.equal(.wrap)
        label.tg_centerY.equal(0)
        label.tg_right.equal(100%)
        createLayout.addSubview(label)
        
        let banksView = BanksView()
        banksView.tg_centerY.equal(0)
        createLayout.addSubview(banksView)
        createLayout.addSubview(addCardButton)
        
        cardItemsLayout.tg_width.equal(.fill)
        cardItemsLayout.tg_height.equal(.wrap)
        creditCardView.insertSubview(cardItemsLayout, at: 0)
        
        if displayStyle != .confirm {
            cardConfirmButton.isHidden = true
            cardConfirmButton.tg_bottom.equal(16)
            creditCardView.addSubview(cardConfirmButton)
            cardConfirmButton.addTarget(self, action: #selector(onCardConfirm(_:)), for: .touchUpInside)
        }
        
        return creditCardView
    }
    
    private func createAddCardButton() -> UIButton {
        let backgroundColor = WonderPayment.uiConfig.primaryButtonBackground
        let tintColor = WonderPayment.uiConfig.primaryButtonColor
        let button = Button()
        button.setImage("add".svg?.withTintColor(tintColor), for: .normal)
        button.tg_width.equal(24)
        button.tg_height.equal(24)
        button.tg_centerY.equal(0)
        button.tg_left.equal(6)
        button.layer.cornerRadius = 12
        button.backgroundColor = backgroundColor
        return button
    }
}
