
import TangramKit

class SuccessfulView : TGLinearLayout {
    
    lazy var amountLabel = Label("HK$0.00",size: 28, fontStyle: .bold)
    lazy var detailsLayout = TGLinearLayout(.vert)
    
    convenience init() {
        self.init(frame: .zero, orientation: .vert)
        self.initView()
    }
    
    private func initView() {
        self.tg_vspace = 16
        self.tg_width.equal(.fill)
        self.tg_height.equal(.wrap)
        
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
        
        amountLabel.tg_width.equal(.fill)
        amountLabel.tg_top.equal(16)
        amountLabel.textAlignment = .center
        layout1.addSubview(amountLabel)
        
        detailsLayout.tg_width.equal(.fill)
        detailsLayout.tg_height.equal(.wrap)
        detailsLayout.layer.borderColor = WonderPayment.uiConfig.primaryButtonColor.cgColor
        detailsLayout.layer.borderWidth = 1
        detailsLayout.layer.cornerRadius = 12
        detailsLayout.clipsToBounds = true
        addSubview(detailsLayout)
        
    }
    
    func setData(_ data: PayResult, intent: PaymentIntent) {
        let currency = data.currency ?? "HKD"
        let amount = data.amount ?? 0.00
        let amountText = "\(CurrencySymbols.get(currency))\(formatAmount(amount))"
        amountLabel.text = amountText
        
        detailsLayout.tg_removeAllSubviews()
        
        let headerLayout = TGLinearLayout(.horz)
        headerLayout.tg_width.equal(.fill)
        headerLayout.tg_height.equal(.wrap)
        headerLayout.tg_padding = UIEdgeInsets.all(16)
        headerLayout.backgroundColor = WonderPayment.uiConfig.secondaryBackground
        detailsLayout.addSubview(headerLayout)

        let orderNumberLabel = Label(data.referenceId ?? "")
        orderNumberLabel.tg_width.equal(.fill)
        orderNumberLabel.tg_height.equal(.wrap)
        headerLayout.addSubview(orderNumberLabel)

        let itemsLayout = TGLinearLayout(.vert)
        itemsLayout.tg_padding = UIEdgeInsets.all(16)
        itemsLayout.tg_width.equal(.fill)
        itemsLayout.tg_height.equal(.wrap)
        itemsLayout.tg_vspace = 16
        detailsLayout.addSubview(itemsLayout)
        
        itemsLayout.addSubview(KeyValueItem(key: "paymentAmount".i18n, value: amountText))
        
        let paymentData = DynamicJson(value: data.paymentData)
        
        if let nameAndIcon = getNameAndIcon(intent.paymentMethod?.type.rawValue) {
            itemsLayout.addSubview(KeyValueItem(key: "paymentMethod".i18n, value: nameAndIcon.0, valueIcon: nameAndIcon.1))
        }
        
        if let transactionId = paymentData["new_gateway_txn_id"].string {
            itemsLayout.addSubview(KeyValueItem(key: "transactionID".i18n, value: transactionId))
        }
        
        if let rrn = paymentData["rrn"].string {
            itemsLayout.addSubview(KeyValueItem(key: "RRN".i18n, value: rrn))
        }
        
        if let dic = intent.paymentMethod?.arguments as? NSDictionary, let customerName = dic["holder_name"] as? String {
            itemsLayout.addSubview(KeyValueItem(key: "customerName".i18n, value: customerName))
        }
        
        if let createdAt = data.createdAt {
            var formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let localDate = formatter.date(from: createdAt) {
                formatter = DateFormatter()
                formatter.dateFormat = "d MMM yyyy,HH:mm:ss"
                let formatted = formatter.string(from: localDate)
                itemsLayout.addSubview(KeyValueItem(key: "transactionTime".i18n, value: formatted))
            }
        }
        
        itemsLayout.addSubview(KeyValueItem(key: "invoiceAmount".i18n, value: amountText))
    }
    
    private func getNameAndIcon(_ key: String?) -> (String, UIImage?)? {
        let methodsData = [
            "apple_pay": ("Apple Pay", "ApplePay2".svg),
            "unionpay_wallet": ("unionPay".i18n, "UnionPay".svg),
            "wechatpay": ("wechatPay".i18n, "WechatPay".svg),
            "alipay_hk": ("alipayHK".i18n, "Alipay".svg),
            "alipay": ("alipay".i18n, "Alipay".svg),
            "credit_cards": ("card".i18n, nil),
        ]
        return methodsData[key ?? ""]
    }
}
