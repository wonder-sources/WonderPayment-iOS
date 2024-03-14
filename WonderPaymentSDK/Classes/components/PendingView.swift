import QMUIKit
import TangramKit

class PendingView : TGLinearLayout {
    
    lazy var paymentItem = KeyValueItem(key: "payment".i18n, value: "")
    lazy var initAtItem = KeyValueItem(key: "initiatedAt".i18n, value: "")
    
    convenience init() {
        self.init(frame: .zero, orientation: .vert)
        self.initView()
    }
    
    private func initView() {
        self.tg_padding = UIEdgeInsets.all(16)
        self.layer.borderColor = WonderPayment.uiConfig.primaryButtonColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        
        let icon = UIImageView(image: "pending".svg)
        icon.tg_centerX.equal(0)
        addSubview(icon)
        
        let titleLabel = Label("unfinishedPayment".i18n,size: 18, fontStyle: .medium)
        titleLabel.tg_centerX.equal(0)
        titleLabel.tg_top.equal(8)
        addSubview(titleLabel)
        
        let whyButton = QMUIButton()
        whyButton.setTitle("whySeeingThis".i18n, for: .normal)
        whyButton.setTitleColor(WonderPayment.uiConfig.linkColor, for: .normal)
        whyButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        whyButton.tg_top.equal(16)
        whyButton.tg_width.equal(.wrap)
        whyButton.tg_height.equal(.wrap)
        whyButton.tg_centerX.equal(0)
        addSubview(whyButton)
        whyButton.addTarget(self, action: #selector(showWhyPendingDialog(_:)), for: .touchUpInside)
        
        paymentItem.tg_top.equal(16)
        addSubview(paymentItem)
        
        let statusItem = KeyValueItem(key: "status".i18n, value: "pending".i18n)
        statusItem.tg_top.equal(10)
        addSubview(statusItem)
        
        initAtItem.tg_top.equal(10)
        addSubview(initAtItem)
    }
    
    @objc private func showWhyPendingDialog(_ sender: UIView) {
        let dialog = WhyPendingDialog()
        dialog.show()
    }
}
