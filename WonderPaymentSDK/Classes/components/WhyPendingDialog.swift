import QMUIKit
import TangramKit

class WhyPendingDialog : TGRelativeLayout {
    
    lazy var contentView = TGLinearLayout(.vert)
    
    convenience init() {
        self.init(frame: .zero)
        self.initView()
    }
    
    private func initView() {
        self.tg_height.equal(.fill)
        self.tg_width.equal(.fill)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        contentView.backgroundColor = WonderPayment.uiConfig.background
        contentView.tg_width.equal(.fill)
        let screenSize = UIScreen.main.bounds
        let minSize = screenSize.height - 44 - QMUIHelper.safeAreaInsetsForDeviceWithNotch.top
        contentView.tg_height.equal(.wrap).min(minSize)
        contentView.tg_bottom.equal((-100)%)
        contentView.layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.tg_padding = UIEdgeInsets.only(top: 12, bottom: 60)
        contentView.addGestureRecognizer(UITapGestureRecognizer())
        addSubview(contentView)
        
        let closeButton = QMUIButton()
        closeButton.setImage("close".svg, for: .normal)
        closeButton.tg_right.equal(12)
        closeButton.tg_width.equal(18)
        closeButton.tg_height.equal(18)
        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        contentView.addSubview(closeButton)
        
        let titleLabel = Label("pendingPayment".i18n, size: 18)
        titleLabel.tg_top.equal(8)
        titleLabel.tg_width.equal(.fill)
        titleLabel.tg_left.equal(20)
        titleLabel.tg_right.equal(20)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        let conent = "pendingPaymentDesc".i18n
        let conentLabel = Label(conent)
        conentLabel.tg_top.equal(24)
        conentLabel.tg_width.equal(.fill)
        conentLabel.tg_left.equal(20)
        conentLabel.tg_right.equal(20)
        contentView.addSubview(conentLabel)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
    }
    
    
    
    @objc func dismiss() {
        contentView.tg_bottom.equal((-100)%)
        tg_layoutAnimationWithDuration(0.3)
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            [weak self] in
            self?.removeFromSuperview()
        })
        
    }
    
    func show() {
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            [weak self] in
            self?.contentView.tg_bottom.equal(0)
            self?.tg_layoutAnimationWithDuration(0.3)
        })
    }
}
