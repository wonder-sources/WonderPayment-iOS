//
//  AutoDebitDialog.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/7/9.
//

import QMUIKit
import TangramKit

class AutoDebitDialog : TGRelativeLayout {
    
    enum AutoDebitType {
        case wechatPay, alipay, alipayHK
    }
    
    lazy var contentView = TGLinearLayout(.vert)
    var callback: ((Int) -> Void)?
    let amount: String
    let type: AutoDebitType
    
    var typeNameAndIcon: (String, UIImage?) {
        switch (type) {
        case .wechatPay:
            return ("wechatPay".i18n, "WechatPay".svg)
        case .alipay:
            return ("alipay".i18n, "Alipay".svg)
        case .alipayHK:
            return ("alipayHK".i18n, "AlipayHK".svg)
        }
    }
    
    init(type: AutoDebitType, amount: String) {
        self.type = type
        self.amount = amount
        super.init(frame: .zero)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.tg_height.equal(.fill)
        self.tg_width.equal(.fill)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        contentView.backgroundColor = WonderPayment.uiConfig.background
        contentView.tg_width.equal(.fill)
        let screenSize = UIScreen.main.bounds
        let minSize = screenSize.height - 44 - safeInsets.top
        contentView.tg_height.equal(.wrap).min(minSize)
        contentView.tg_bottom.equal((-100)%)
        contentView.layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.tg_padding = UIEdgeInsets.only(top: 12)
        contentView.addGestureRecognizer(UITapGestureRecognizer())
        addSubview(contentView)
        
        let closeButton = QMUIButton()
        closeButton.setImage("close".svg, for: .normal)
        closeButton.tg_right.equal(12)
        closeButton.tg_width.equal(24)
        closeButton.tg_height.equal(24)
        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        contentView.addSubview(closeButton)
        
        let nameAndIcon = typeNameAndIcon
        
        let titleLabel = Label(String(format: "enableNoPassword".i18n, nameAndIcon.0), size: 18, fontStyle: .medium)
        titleLabel.tg_top.equal(8)
        titleLabel.tg_width.equal(250)
        titleLabel.tg_centerX.equal(0)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        let imageView = SvgImageView(named: "no_password")
        imageView.tg_top.equal(24)
        imageView.tg_centerX.equal(0)
        imageView.tg_width.equal(.wrap)
        imageView.tg_height.equal(.wrap)
        contentView.addSubview(imageView)
        
        let content = String(format: "chooseAutoDebit".i18n, nameAndIcon.0, nameAndIcon.0)
        let attributedText = NSMutableAttributedString(string: content, attributes: [
            .foregroundColor: WonderPayment.uiConfig.primaryTextColor,
            .font: UIFont(name: "Outfit-Regular", size: 16)!
        ])
        
        let contentLabel = UILabel()
        contentLabel.tg_top.equal(24)
        contentLabel.tg_left.equal(32)
        contentLabel.tg_right.equal(32)
        contentLabel.tg_height.equal(.wrap)
         contentLabel.attributedText = attributedText
        contentView.addSubview(contentLabel)
        
        
        let enableButton = Button(title: String(format: "enablePasswordLess".i18n, nameAndIcon.0), image: nameAndIcon.1, imageSpacing: 16, style: .primary)
        enableButton.tg_height.equal(58)
        enableButton.tg_top.equal(100%)
        enableButton.tg_left.equal(24)
        enableButton.tg_right.equal(24)
        contentView.addSubview(enableButton)
        enableButton.addTarget(self, action: #selector(enablePasswordLess), for: .touchUpInside)
        
        let directlyButton = Button(title: String(format: "directlyPay".i18n, amount), style: .secondary)
        directlyButton.tg_height.equal(58)
        directlyButton.tg_top.equal(12)
        directlyButton.tg_left.equal(24)
        directlyButton.tg_right.equal(24)
        directlyButton.tg_bottom.equal(24 + safeInsets.bottom)
        contentView.addSubview(directlyButton)
        directlyButton.addTarget(self, action: #selector(directlyPay), for: .touchUpInside)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
    }
    
    @objc func enablePasswordLess() {
        close(result: 1)
    }
    
    @objc func directlyPay() {
        close(result: 2)
    }
    
    @objc func dismiss() {
        close()
    }
    
    func close(result: Int = 0) {
        contentView.tg_bottom.equal((-100)%)
        tg_layoutAnimationWithDuration(0.3)
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            [weak self] in
            self?.removeFromSuperview()
            self?.callback?(result)
        })
    }
    
    func show(callback: ((Int) -> Void)? = nil) {
        self.callback = callback
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            [weak self] in
            self?.contentView.tg_bottom.equal(0)
            self?.tg_layoutAnimationWithDuration(0.3)
        })
    }
}

