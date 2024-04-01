import QMUIKit
import TangramKit

protocol MethodItemView {
    var isSelected: Bool { get set }
    var method: PaymentMethod? { get set }
}

protocol MethodViewDelegate {
    /// 选择改变
    func onSelectedChange(selected: PaymentMethod?)
    /// 选择确认
    func onSelectedConfirm(selected: PaymentMethod)
}

class MethodView : TGLinearLayout {
    
    var displayStyle: DisplayStyle = .oneClick
    
    lazy var applePayButton = ApplePayButton(displayStyle: displayStyle)
    lazy var unionPayButton = MethodButton(image: "UnionPay", title: "unionPay".i18n, displayStyle: displayStyle)
    lazy var wechatPayButton = MethodButton(image: "WechatPay", title: "wechatPay".i18n, displayStyle: displayStyle)
    lazy var alipayButton = MethodButton(image: "Alipay", title: "alipay".i18n, displayStyle: displayStyle)
    lazy var alipayHKButton = MethodButton(image: "Alipay", title: "alipayHK".i18n, displayStyle: displayStyle)
    lazy var addCardButton = createAddCardButton()
    lazy var cardView = createCardView()
    lazy var itemsLayout = TGLinearLayout(.vert)
    lazy var cardConfirmButton = Button(title: "confirm".i18n, style: .secondary)
    
    var lastSelected: MethodItemView?
    
    var selectedMethod: PaymentMethod? {
        didSet{
            cardConfirmButton.isHidden = displayStyle == .confirm || selectedMethod?.type != .creditCard
            delegate?.onSelectedChange(selected: selectedMethod)
        }
    }
    
    var delegate: MethodViewDelegate?

    convenience init(displayStyle: DisplayStyle = .oneClick) {
        self.init(frame: .zero, orientation: .vert)
        self.displayStyle = displayStyle
        self.initView()
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
        applePayButton.addTarget(self, action: #selector(onMethodItemClick(_:)), for: .touchUpInside)
        unionPayButton.addTarget(self, action: #selector(onMethodItemClick(_:)), for: .touchUpInside)
        wechatPayButton.addTarget(self, action: #selector(onMethodItemClick(_:)), for: .touchUpInside)
        alipayButton.addTarget(self, action: #selector(onMethodItemClick(_:)), for: .touchUpInside)
        alipayHKButton.addTarget(self, action: #selector(onMethodItemClick(_:)), for: .touchUpInside)
        
        addSubview(applePayButton)
        addSubview(unionPayButton)
        addSubview(wechatPayButton)
        addSubview(alipayButton)
        addSubview(alipayHKButton)
        
        
        if displayStyle == .confirm {
            insertSubview(cardView, at: 0)
        } else {
            addSubview(cardView)
        }
        
        unionPayButton.isHidden = true
        wechatPayButton.isHidden = true
        alipayButton.isHidden = true
        alipayHKButton.isHidden = true
        cardView.isHidden = true
    }
    
    func setCardItems(_ items: [CreditCardInfo]) {
        for subview in itemsLayout.subviews {
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
            divider.backgroundColor = UIColor(hexString: "#FFE4E4E4")
            divider.tg_width.equal(.fill)
            divider.tg_height.equal(1)
            
            if displayStyle == .oneClick {
                itemsLayout.addSubview(divider)
            }

            for index in 0..<items.count {
                let item = items[index]
                let icon = CardMap.getIcon(item.issuer ?? "")
                let cardNumber = formatCardNumber(issuer: item.issuer ?? "", number: item.number ?? "")
//                let isSelected = item.default ?? false
                let itemView = CardItemView(icon: icon, cardNumber: cardNumber,isSelected: isSelected, displayStyle: displayStyle)
                itemView.method = trans2PaymentMethod(item)
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
                itemsLayout.addSubview(itemView)
            }
            
            if displayStyle == .confirm {
                itemsLayout.addSubview(divider)
            }
        }
    }
    
    private func trans2PaymentMethod(_ cardInfo: CreditCardInfo) -> PaymentMethod {
        let firstName = cardInfo.holderFirstName ?? ""
        let lastName = cardInfo.holderLastName ?? ""
        let expYear = cardInfo.expYear ?? ""
        let expMonth = cardInfo.expMonth ?? ""
        let args: [String : Any?] = [
            "exp_date": "\(expYear)\(expMonth)",
            "exp_year": expYear,
            "exp_month": expMonth,
            "number": cardInfo.number,
            "token": cardInfo.token,
            "holder_name": cardInfo.holderName,
            "card_reader_mode": "manual",
            "billing_address": [
                "first_name": firstName,
                "last_name": lastName,
                "phone_number": cardInfo.phone,
            ],
        ]
        return PaymentMethod(type: .creditCard, arguments: args)
    }
    
    @objc private func onMethodItemClick(_ sender: Any) {
        var itemView : MethodItemView
        if sender is UITapGestureRecognizer {
            itemView = (sender as! UITapGestureRecognizer).view as! MethodItemView
        } else {
            itemView = sender as! MethodItemView
        }
        let method = itemView.method
        if displayStyle == .oneClick && method?.type != .creditCard {
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
        creditCardView.tg_width.equal(.fill)
        creditCardView.tg_height.equal(.wrap).min(56)
        creditCardView.tg_padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let createLayout = TGLinearLayout(.horz)
        createLayout.tg_width.equal(.fill)
        createLayout.tg_height.equal(56)
        creditCardView.addSubview(createLayout)
        
        let label = UILabel()
        label.text = "card".i18n
        label.font = UIFont(name: "Futura-Medium", size: 16)
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
        
        itemsLayout.tg_width.equal(.fill)
        itemsLayout.tg_height.equal(.wrap)
        if displayStyle == .confirm {
            creditCardView.insertSubview(itemsLayout, at: 0)
        } else {
            creditCardView.addSubview(itemsLayout)
        }
        
        if displayStyle != .confirm {
            cardConfirmButton.isHidden = true
            cardConfirmButton.tg_bottom.equal(16)
            creditCardView.addSubview(cardConfirmButton)
            cardConfirmButton.addTarget(self, action: #selector(onCardConfirm(_:)), for: .touchUpInside)
        }
        
        return creditCardView
    }
    
    private func createAddCardButton() -> UIButton {
        let button = QMUIButton()
        button.setImage("add".svg, for: .normal)
        button.tg_width.equal(.wrap)
        button.tg_height.equal(.wrap)
        button.tg_centerY.equal(0)
        button.tg_left.equal(6)
        return button
    }
}
