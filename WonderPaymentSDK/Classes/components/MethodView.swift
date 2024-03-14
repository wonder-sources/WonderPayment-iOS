import QMUIKit
import TangramKit

class MethodView : TGLinearLayout {
    
    var selectMode = false
    lazy var unionPayButton = createButton(image: "UnionPay", title: "unionPay".i18n, selectMode: selectMode)
    lazy var wechatPayButton = createButton(image: "WechatPay", title: "wechatPay".i18n, selectMode: selectMode)
    lazy var alipayButton = createButton(image: "Alipay", title: "alipay".i18n, selectMode: selectMode)
    lazy var alipayHKButton = createButton(image: "Alipay", title: "alipayHK".i18n, selectMode: selectMode)
    lazy var addCardButton = createAddCardButton()
    lazy var cardView = createCardView()
    lazy var itemsLayout = TGLinearLayout(.vert)
    lazy var cardConfirmButton = Button(title: "confirm".i18n, style: .secondary)
    
    var items: [CreditCardInfo]?
    var lastSelectedItemView: CardItemView?
    
    var selectedCard: CreditCardInfo? {
        didSet {
            cardConfirmButton.isHidden = selectedCard == nil
        }
    }
    
    convenience init(selectMode: Bool = false) {
        self.init(frame: .zero, orientation: .vert)
        self.selectMode = selectMode
        self.initView()
    }
    
    private func initView() {
        self.tg_vspace = 16
        self.tg_width.equal(.fill)
        self.tg_height.equal(.wrap)
        
        addSubview(unionPayButton)
        addSubview(wechatPayButton)
        addSubview(alipayButton)
        addSubview(alipayHKButton)
        
        
        if WonderPayment.uiConfig.creditCardTop {
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
        self.items = items
        selectedCard = nil
        for subview in itemsLayout.subviews {
            subview.removeFromSuperview()
        }
        
        if (!items.isEmpty) {
            let divider = UIView()
            divider.backgroundColor = .black.withAlphaComponent(0.2)
            divider.tg_width.equal(.fill)
            divider.tg_height.equal(QMUIHelper.pixelOne)
            itemsLayout.addSubview(divider)

            for index in 0..<items.count {
                let item = items[index]
                let icon = CardMap.getIcon(item.issuer ?? "")
                let cardNumber = formatCardNumber(issuer: item.issuer ?? "", number: item.number ?? "")
                let isSelected = item.default ?? false
                let itemView = CardItemView(icon: icon, cardNumber: cardNumber,isSelected: isSelected, selectMode: selectMode)
                itemsLayout.addSubview(itemView)
                if isSelected {
                    selectedCard = item
                    lastSelectedItemView?.isSelected = false
                    lastSelectedItemView = itemView
                }
                itemView.tag = index
                itemView.addGestureRecognizer(
                    UITapGestureRecognizer(
                        target: self,
                        action: #selector(onItemClick(_:))
                    )
                )
            }
        }
    }
    
    @objc private func onItemClick(_ sender: UITapGestureRecognizer) {
        let itemView = sender.view as! CardItemView
        if (!itemView.isSelected) {
            itemView.isSelected = true
            selectedCard = items?[itemView.tag]
            lastSelectedItemView?.isSelected = false
            lastSelectedItemView = itemView
        }
    }
    
    private func createButton(image: String, title: String, selectMode: Bool = false) -> UIButton {
        let button = QMUIButton()
        button.backgroundColor = WonderPayment.uiConfig.primaryButtonBackground
        button.layer.borderWidth = 1
        button.layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        button.tg_width.equal(.fill)
        button.tg_height.equal(56)
        
        let child = TGLinearLayout(.horz)
        child.tg_padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        child.tg_width.equal(.fill)
        child.tg_height.equal(.fill)
        child.isUserInteractionEnabled = false
        button.addSubview(child)
        
        let icon = UIImageView(image: image.svg)
        icon.contentMode = .scaleAspectFit
        icon.tg_width.equal(48)
        icon.tg_height.equal(25)
        icon.tg_centerY.equal(0)
        child.addSubview(icon)
        
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "Futura-Medium", size: 16)
        label.textColor = WonderPayment.uiConfig.primaryButtonColor
        label.tg_left.equal(8)
        label.tg_width.equal(.wrap)
        label.tg_height.equal(.wrap)
        label.tg_centerY.equal(0)
        child.addSubview(label)
        
        let radioButton = RadioButton(style: .radio)
        radioButton.tg_left.equal(100%)
        radioButton.tg_width.equal(.wrap)
        radioButton.tg_height.equal(.wrap)
        radioButton.tg_centerY.equal(0)
        child.addSubview(radioButton)
        
        if !selectMode {
            icon.tg_left.equal(100%)
            radioButton.alpha = 0
        }
        
        return button
    }
    
    private func createCardView() -> UIView {
        let creditCardView = TGLinearLayout(.vert)
        creditCardView.backgroundColor = WonderPayment.uiConfig.primaryButtonBackground
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
        label.textColor = WonderPayment.uiConfig.primaryButtonColor
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
        creditCardView.addSubview(itemsLayout)
        
        if !selectMode {
            cardConfirmButton.isHidden = true
            cardConfirmButton.tg_bottom.equal(16)
            creditCardView.addSubview(cardConfirmButton)
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
