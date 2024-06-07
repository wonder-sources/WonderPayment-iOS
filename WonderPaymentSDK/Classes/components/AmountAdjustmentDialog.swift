//
//  AmountAdjustmentDialog.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/5/21.
//

import QMUIKit
import TangramKit

class AmountAdjustmentDialog : TGRelativeLayout {
    
    lazy var contentView = TGLinearLayout(.vert)
    var callback: ((Int) -> Void)?
    let originalAmount: String
    let adjustedAmount: String
    
    init(originalAmount: String, adjustedAmount: String) {
        self.originalAmount = originalAmount
        self.adjustedAmount = adjustedAmount
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
        
        let titleLabel = Label("amountAdjustment".i18n, size: 18, fontStyle: .medium)
        titleLabel.tg_top.equal(8)
        titleLabel.tg_width.equal(.fill)
        titleLabel.tg_left.equal(20)
        titleLabel.tg_right.equal(20)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        let content = String(format: "amountAdjustmentDesc".i18n, originalAmount, adjustedAmount) 
        let attributedText = NSMutableAttributedString(string: content, attributes: [
            .foregroundColor: WonderPayment.uiConfig.primaryTextColor,
            .font: UIFont(name: "Outfit-Regular", size: 16)!
        ])
        let range1 = (content as NSString).range(of: originalAmount)
        let range2 = (content as NSString).range(of: adjustedAmount)
        attributedText.addAttributes([.foregroundColor: WonderPayment.uiConfig.successColor], range: range1)
        attributedText.addAttributes([.foregroundColor: WonderPayment.uiConfig.successColor], range: range2)
        
        let contentLabel = UILabel()
        contentLabel.tg_top.equal(24)
        contentLabel.tg_width.equal(.fill)
        contentLabel.tg_left.equal(32)
        contentLabel.tg_right.equal(32)
        contentLabel.tg_width.equal(.wrap)
        contentLabel.tg_height.equal(.wrap)
        contentLabel.attributedText = attributedText
        contentView.addSubview(contentLabel)
        
        let continueButton = Button(title: "continuePayment".i18n, style: .primary)
        continueButton.tg_top.equal(100%)
        continueButton.tg_left.equal(24)
        continueButton.tg_right.equal(24)
        contentView.addSubview(continueButton)
        continueButton.addTarget(self, action: #selector(continuePay), for: .touchUpInside)
        
        let backButton = Button(title: "back".i18n, style: .secondary)
        backButton.tg_top.equal(12)
        backButton.tg_left.equal(24)
        backButton.tg_right.equal(24)
        backButton.tg_bottom.equal(24 + safeInsets.bottom)
        contentView.addSubview(backButton)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
    }
    
    @objc func continuePay() {
        close(result: 1)
    }
    
    @objc func back() {
        close()
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

