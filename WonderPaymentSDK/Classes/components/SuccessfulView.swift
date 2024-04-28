
import TangramKit

class SuccessfulView : TGLinearLayout {
    
    lazy var amountLabel = Label("HK$0.00",size: 28, fontStyle: .bold)
    lazy var titleLabel = Label("successfulPayment".i18n,size: 18, fontStyle: .medium)
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
        layout1.layer.borderColor = WonderPayment.uiConfig.secondaryButtonColor.cgColor
        layout1.layer.borderWidth = 1
        layout1.layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        addSubview(layout1)
        
        let icon = UIImageView(image: "successful".svg)
        icon.tg_centerX.equal(0)
        layout1.addSubview(icon)
        
        titleLabel.textAlignment = .center
        titleLabel.tg_centerX.equal(0)
        titleLabel.tg_top.equal(8)
        layout1.addSubview(titleLabel)
        
        amountLabel.tg_width.equal(.fill)
        amountLabel.tg_top.equal(16)
        amountLabel.textAlignment = .center
        layout1.addSubview(amountLabel)
        
        detailsLayout.tg_width.equal(.fill)
        detailsLayout.tg_height.equal(.wrap)
        detailsLayout.layer.borderColor = WonderPayment.uiConfig.secondaryButtonColor.cgColor
        detailsLayout.layer.borderWidth = 1
        detailsLayout.layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        detailsLayout.clipsToBounds = true
        addSubview(detailsLayout)
        
    }
    
    func setData(_ data: PayResult, intent: PaymentIntent) {
        if (intent.transactionType == .preAuth) {
            titleLabel.text = "successfulPreAuth".i18n
        }
        
        let currency = data.transaction?.currency ?? "HKD"
        let amount = data.transaction?.amount ?? 0.00
        let amountText = "\(CurrencySymbols.get(currency))\(formatAmount(amount))"
        amountLabel.text = amountText
        
        detailsLayout.tg_removeAllSubviews()
        
        let headerLayout = TGLinearLayout(.horz)
        headerLayout.tg_width.equal(.fill)
        headerLayout.tg_height.equal(.wrap)
        headerLayout.tg_padding = UIEdgeInsets.all(16)
        headerLayout.backgroundColor = WonderPayment.uiConfig.secondaryBackground
        detailsLayout.addSubview(headerLayout)

        let orderNumberLabel = Label(data.order.referenceNumber)
        orderNumberLabel.tg_width.equal(.fill)
        orderNumberLabel.tg_height.equal(.wrap)
        headerLayout.addSubview(orderNumberLabel)

        let itemsLayout = TGLinearLayout(.vert)
        itemsLayout.tg_padding = UIEdgeInsets.all(16)
        itemsLayout.tg_width.equal(.fill)
        itemsLayout.tg_height.equal(.wrap)
        itemsLayout.tg_vspace = 16
        detailsLayout.addSubview(itemsLayout)
        
        if intent.transactionType == .sale {
            itemsLayout.addSubview(KeyValueItem(key: "paymentAmount".i18n, value: amountText))
        }
        
        let paymentData = DynamicJson(value: data.transaction?.paymentData)
        let type = paymentData["acquirer_type"].string ?? ""
        if let methodType = PaymentMethodType(rawValue: type) {
            let nameAndIcon = getMethodNameAndIcon(PaymentMethod(type: methodType))
            itemsLayout.addSubview(KeyValueItem(key: "paymentMethod".i18n, value: nameAndIcon.0, valueIcon: nameAndIcon.1?.svg))
        } else {
            if CardMap.names.keys.contains(type) {
                let name = CardMap.getName(type)
                let icon = CardMap.getIcon(type)
                let last4 = paymentData["last_4_digits"].string ?? ""
                itemsLayout.addSubview(KeyValueItem(key: "paymentMethod".i18n, value: "\(name)**\(last4)", valueIcon: icon.svg))
            }
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
        
        if let createdAt = data.transaction?.createdAt {
            let utcISODateFormatter = ISO8601DateFormatter()
            if let localDate = utcISODateFormatter.date(from: createdAt) {
                let formatter = DateFormatter()
                formatter.dateFormat = "d MMM yyyy,HH:mm:ss"
                
                let formatted = formatter.string(from: localDate)
                itemsLayout.addSubview(KeyValueItem(key: "transactionTime".i18n, value: formatted))
            }
        }
        
        if intent.transactionType == .sale {
            itemsLayout.addSubview(KeyValueItem(key: "invoiceAmount".i18n, value: amountText))
        }
        if intent.transactionType == .preAuth {
            itemsLayout.addSubview(KeyValueItem(key: "preAuthAmount".i18n, value: amountText))
        }
    }
    
}
