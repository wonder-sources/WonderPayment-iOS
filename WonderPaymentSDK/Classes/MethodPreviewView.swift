//
//  MethodPreviewView.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/4/15.
//

import Foundation
import TangramKit
import QMUIKit
import SVGKit

class MethodPreviewView: TGLinearLayout {
    lazy var titleBar = initTitleBar()
    var cardView: CardView?
    var otherMethodView: OtherMethodView?
    let paymentMethod: PaymentMethod
    
    init(method: PaymentMethod) {
        self.paymentMethod = method
        super.init(frame: .zero, orientation: .vert)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.backgroundColor = WonderPayment.uiConfig.background
        self.tg_height.equal(.fill)
        self.tg_width.equal(.fill)
        addSubview(titleBar)
        
        let scrollView = ScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.tg_width.equal(.fill)
        scrollView.tg_height.equal(.fill)
        addSubview(scrollView)
        
        let screenHeight = UIScreen.main.bounds.height
        let safeAreaInsets = QMUIHelper.safeAreaInsetsForDeviceWithNotch
        let contentHeight = screenHeight - safeAreaInsets.top - safeAreaInsets.bottom - 44
        
        let contentView = TGLinearLayout(.vert)
        contentView.tg_width.equal(.fill)
        contentView.tg_height.equal(.wrap).min(contentHeight)
        scrollView.addSubview(contentView)
        
        if paymentMethod.type == .creditCard {
            cardView = CardView(method: paymentMethod)
            contentView.addSubview(cardView!)
        } else {
            otherMethodView = OtherMethodView(method: paymentMethod)
            contentView.addSubview(otherMethodView!)
        }
        
        let poweredLabel = Label("Powered by Wonder.app", size: 12, fontStyle: .medium)
        poweredLabel.textColor = WonderPayment.uiConfig.primaryTextColor
        poweredLabel.tg_width.equal(.wrap)
        poweredLabel.tg_height.equal(.wrap)
        poweredLabel.tg_centerX.equal(0)
        poweredLabel.tg_top.equal(100%).min(16)
        poweredLabel.tg_bottom.equal(16)
        contentView.addSubview(poweredLabel)
    }
    
    private func initTitleBar() -> TitleBar{
        let titleBar = TitleBar()
        titleBar.backgroundColor = WonderPayment.uiConfig.background
        titleBar.titleLabel.text = "paymentMethod".i18n
        titleBar.titleLabel.textColor = WonderPayment.uiConfig.primaryTextColor
        titleBar.titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleBar.leftView.setImage(
            "back".svg?.qmui_image(withTintColor: WonderPayment.uiConfig.primaryTextColor),
            for: .normal
        )
        
        return titleBar
    }
    
    class CardView : TGLinearLayout {
        
        let paymentMethod: PaymentMethod
        lazy var deleteButton = Button(title: "deleteThisCard".i18n, style: .warning)
        
        init(method: PaymentMethod) {
            self.paymentMethod = method
            super.init(frame: .zero, orientation: .vert)
            self.initView()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func initView() {
            let dynamicJson = DynamicJson(value: paymentMethod.arguments)
            let issuer = dynamicJson["issuer"].string ?? ""
            let issuerName = CardMap.getName(issuer)
            let number = dynamicJson["number"].string ?? ""
            let suffix = number.count > 4 ? String(number.suffix(4)) : number
            let holderName = dynamicJson["holder_name"].string ?? ""
            
            self.tg_height.equal(.wrap)
            self.tg_width.equal(.fill)
            self.tg_top.equal(26)
            self.tg_horzMargin(24)
            
            let cardInfoLayout = TGLinearLayout(.vert)
            cardInfoLayout.backgroundColor = .white
            cardInfoLayout.layer.cornerRadius = WonderPayment.uiConfig.borderRadius
            cardInfoLayout.tg_padding = .all(16)
            cardInfoLayout.tg_height.equal(.wrap)
            cardInfoLayout.tg_width.equal(.fill)
            self.addSubview(cardInfoLayout)
            
            let cardNumberLayout = TGLinearLayout(.horz)
            cardNumberLayout.tg_width.equal(.fill)
            cardNumberLayout.tg_height.equal(.wrap)
            cardInfoLayout.addSubview(cardNumberLayout)
            
            let leftLayout = TGLinearLayout(.vert)
            leftLayout.tg_width.equal(.wrap)
            leftLayout.tg_height.equal(.wrap)
            cardNumberLayout.addSubview(leftLayout)
            
            let cardLabel = Label(issuerName, color: .black,size: 18, fontStyle: .bold)
            leftLayout.addSubview(cardLabel)
            
            let cardNumberLabel = Label("**** \(suffix)", color: .black,size: 18, fontStyle: .bold)
            cardNumberLabel.tg_top.equal(8)
            leftLayout.addSubview(cardNumberLabel)
            
            let issuerIcon = CardMap.getIcon(issuer)
            if let url = resBundle?.url(forResource: issuerIcon, withExtension: "svg"),
               let svgImage = SVGKImage.init(contentsOf: url)
            {
                let cardIconView = SVGKFastImageView(svgkImage: svgImage)!
                cardIconView.tg_left.equal(100%)
                cardIconView.tg_centerY.equal(0)
                
                cardIconView.tg_height.equal(36)
                cardNumberLayout.addSubview(cardIconView)
                if svgImage.hasSize() {
                    let width = 36 / svgImage.size.height * svgImage.size.width
                    cardIconView.tg_width.equal(width)
                } else {
                    cardIconView.tg_width.equal(.wrap)
                }
            }
            
            let divider = UIView()
            divider.backgroundColor = UIColor(hexString: "#FFE4E4E4")
            divider.tg_top.equal(16)
            divider.tg_width.equal(.fill)
            divider.tg_height.equal(1)
            cardInfoLayout.addSubview(divider)
            
//            let issuerLabel = Label("issuer".i18n, style: .secondary, fontStyle: .bold)
//            issuerLabel.tg_top.equal(16)
//            cardInfoLayout.addSubview(issuerLabel)
            
//            let issuerValueLabel = Label(issuerName, color: .black, fontStyle: .bold)
//            issuerValueLabel.tg_top.equal(8)
//            cardInfoLayout.addSubview(issuerValueLabel)
            
//            let countryLabel = Label("Country", style: .secondary, fontStyle: .bold)
//            countryLabel.tg_top.equal(16)
//            cardInfoLayout.addSubview(countryLabel)
//            
//            let countryValueLabel = Label("Hong Kong", color: .black, fontStyle: .bold)
//            countryValueLabel.tg_top.equal(8)
//            cardInfoLayout.addSubview(countryValueLabel)
            
            let expiryLabel = Label("expiryDate".i18n, style: .secondary, fontStyle: .bold)
            expiryLabel.tg_top.equal(16)
            cardInfoLayout.addSubview(expiryLabel)
            
            let expiryValueLabel = Label("**/**", color: .black, fontStyle: .bold)
            expiryValueLabel.tg_top.equal(8)
            cardInfoLayout.addSubview(expiryValueLabel)
            
            let nameLabel = Label("holderName".i18n, style: .secondary, fontStyle: .bold)
            nameLabel.tg_top.equal(16)
            cardInfoLayout.addSubview(nameLabel)
            
            let nameValueLabel = Label(holderName, color: .black, fontStyle: .bold)
            nameValueLabel.tg_top.equal(8)
            cardInfoLayout.addSubview(nameValueLabel)
            
            deleteButton.tg_top.equal(26)
            self.addSubview(deleteButton)
        }
    }
    
    class OtherMethodView : TGLinearLayout {
        
        let paymentMethod: PaymentMethod
        
        init(method: PaymentMethod) {
            self.paymentMethod = method
            super.init(frame: .zero, orientation: .vert)
            self.initView()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func initView() {
            self.backgroundColor = .white
            self.layer.cornerRadius = WonderPayment.uiConfig.borderRadius
            self.tg_top.equal(26)
            self.tg_horzMargin(24)
            self.tg_height.equal(.wrap)
            self.tg_width.equal(.fill)
            self.tg_padding = UIEdgeInsets.only(top: 16, left: 16, bottom: 30, right: 16)
            
            let methodLayout = TGLinearLayout(.horz)
            methodLayout.tg_width.equal(.fill)
            methodLayout.tg_height.equal(46)
            self.addSubview(methodLayout)
            
            let methodLabel = Label(paymentMethod.name, color: .black, size: 26, fontStyle: .bold)
            methodLabel.tg_centerY.equal(0)
            methodLayout.addSubview(methodLabel)
            
            var image = paymentMethod.icon.svg
            if paymentMethod.type == .applePay {
                image = image?.qmui_image(withTintColor: .black)
            }
            let iconView = UIImageView(image: image)
            iconView.tg_left.equal(100%)
            iconView.tg_centerY.equal(0)
            methodLayout.addSubview(iconView)
            
            
            let divider = UIView()
            divider.backgroundColor = UIColor(hexString: "#FFE4E4E4")
            divider.tg_top.equal(16)
            divider.tg_bottom.equal(16)
            divider.tg_width.equal(.fill)
            divider.tg_height.equal(1)
            self.addSubview(divider)
            
            let label1 = Label(String(format: "payingWith".i18n, paymentMethod.name),color: .black, size: 16, fontStyle: .bold)
            label1.tg_width.equal(.fill)
            label1.tg_height.equal(.wrap)
            self.addSubview(label1)
            
            let label2 = Label(String(format: "canPayUsing".i18n, paymentMethod.name),style: .secondary, size: 16, fontStyle: .bold)
            label2.tg_top.equal(8)
            label2.tg_width.equal(.fill)
            label2.tg_height.equal(.wrap)
            self.addSubview(label2)
        }
    }
}
