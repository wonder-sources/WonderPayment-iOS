import QMUIKit

class ErrorView : TGLinearLayout {
    
    var errorMessage: ErrorMessage? {
        didSet {
            errorCodeLabel.text = errorMessage?.code
            errorMsgLabel.text = errorMessage?.message
        }
    }
    
    lazy var errorCodeLabel = Label(errorMessage?.code ?? "",color: WonderPayment.uiConfig.errorColor, size: 14, fontStyle: .medium)
    lazy var errorMsgLabel = Label(errorMessage?.message ?? "",color: WonderPayment.uiConfig.errorColor, size: 14, fontStyle: .medium)
    lazy var retryButton = QMUIButton()
    
    convenience init() {
        self.init(frame: .zero, orientation: .vert)
        self.initView()
    }
    
    private func initView() {
        self.tg_padding = UIEdgeInsets.all(16)
        self.layer.borderColor = WonderPayment.uiConfig.primaryButtonColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        
        let icon = UIImageView(image: "error".svg)
        icon.tg_centerX.equal(0)
        addSubview(icon)
        
        let titleLabel = Label("paymentFailed".i18n,color: WonderPayment.uiConfig.errorColor, size: 18, fontStyle: .medium)
        titleLabel.tg_width.equal(.fill)
        titleLabel.tg_top.equal(8)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        
        errorCodeLabel.tg_width.equal(.fill)
        errorCodeLabel.tg_top.equal(16)
        errorCodeLabel.textAlignment = .center
        addSubview(errorCodeLabel)
        
        errorMsgLabel.tg_width.equal(.fill)
        errorMsgLabel.tg_top.equal(2)
        errorMsgLabel.textAlignment = .center
        addSubview(errorMsgLabel)
        
        retryButton.tg_width.equal(.fill)
        retryButton.tg_height.equal(52)
        retryButton.tg_top.equal(16)
        retryButton.backgroundColor = WonderPayment.uiConfig.secondaryButtonBackground
        retryButton.layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        retryButton.setTitle("retryPayment".i18n, for: .normal)
        retryButton.setTitleColor(WonderPayment.uiConfig.secondaryButtonColor, for: .normal)
        retryButton.titleLabel?.font = UIFont(name: "Futura-Medium", size: 16)
        addSubview(retryButton)
        
    }
}
