//
//  Dialog.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/3/21.
//

import Foundation
import TangramKit
import QMUIKit

class Dialog {
    
    static func alert(
        icon: UIImage? = nil,
        title: String,
        message: String,
        button: String,
        buttonStyle: Button.ButtonStyle? = nil,
        action: ((QMUIModalPresentationViewController)->Void)? = nil
    ) {
        let controller = QMUIModalPresentationViewController()
        let dialogView = DialogView(icon: icon, title: title, message: message, button1: button, button1Style: buttonStyle, action1: {
            if action == nil {
                controller.hideWith(animated: true)
            } else {
                action?(controller)
            }
        })
        controller.contentViewMargins = UIEdgeInsets.zero
        controller.contentView = dialogView
        controller.isModal = true
        controller.showWith(animated: true)
    }
    
    static func confirm(
        icon: UIImage? = nil,
        title: String,
        message: String,
        button1: String,
        button2: String,
        button1Style: Button.ButtonStyle? = nil,
        button2Style: Button.ButtonStyle? = nil,
        action1: ((QMUIModalPresentationViewController)->Void)? = nil,
        action2: ((QMUIModalPresentationViewController)->Void)? = nil
    ) {
        let controller = QMUIModalPresentationViewController()
        let dialogView = DialogView(
            icon: icon,
            title: title,
            message: message,
            button1: button1,
            button2: button2,
            button1Style: button1Style,
            button2Style: button2Style,
            action1: {
                if action1 == nil {
                    controller.hideWith(animated: true)
                } else {
                    action1?(controller)
                }
            }, 
            action2: {
                if action2 == nil {
                    controller.hideWith(animated: true)
                } else {
                    action2?(controller)
                }
            }
        )
        controller.contentViewMargins = UIEdgeInsets.zero
        controller.contentView = dialogView
        controller.isModal = true
        controller.showWith(animated: true)
    }
}

class DialogView : UIView {
    var icon: UIImage?
    var title: String?
    var message: String?
    var button1: String?
    var button2: String?
    var action1: (()->Void)?
    var action2: (()->Void)?
    var button1Style: Button.ButtonStyle?
    var button2Style: Button.ButtonStyle?
    
    convenience init(
        icon: UIImage? = nil,
        title: String? = nil,
        message: String? = nil,
        button1: String? = nil,
        button2: String? = nil,
        button1Style: Button.ButtonStyle? = nil,
        button2Style: Button.ButtonStyle? = nil,
        action1: (()->Void)? = nil,
        action2: (()->Void)? = nil
    ) {
        self.init(frame: .zero)
        self.icon = icon
        self.title = title
        self.message = message
        self.button1 = button1
        self.button2 = button2
        self.button1Style = button1Style
        self.button2Style = button2Style
        self.action1 = action1
        self.action2 = action2
        self.initView()
    }
    
    private func initView() {
        self.tg_width.equal(.wrap)
        self.tg_height.equal(.wrap)
        
        let contentView = TGLinearLayout(.vert)
        contentView.tg_width.equal(292)
        contentView.tg_height.equal(.wrap)
        contentView.tg_padding = UIEdgeInsets.all(24)
        contentView.backgroundColor = WonderPayment.uiConfig.background
        contentView.layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        addSubview(contentView)
        
        if let icon = icon {
            let iconView = UIImageView(image: icon)
            iconView.tg_centerX.equal(0)
            iconView.tg_bottom.equal(16)
            contentView.addSubview(iconView)
        }
        
        if let title = title {
            let titleLabel = Label(title, fontStyle: .medium)
            titleLabel.tg_width.equal(.fill)
            titleLabel.tg_height.equal(.wrap)
            titleLabel.textAlignment = .center
            contentView.addSubview(titleLabel)
        }
        
        if let message = message {
            let messageLabel = Label(message,style: .secondary, size: 14)
            messageLabel.tg_width.equal(.fill)
            messageLabel.tg_height.equal(.wrap)
            messageLabel.textAlignment = .center
            messageLabel.tg_top.equal(10)
            contentView.addSubview(messageLabel)
        }
        
        if let button1 = button1 {
            let button = Button(title: button1, style: button1Style ?? .primary)
            button.tg_top.equal(20)
            button.tag = 1
            button.addTarget(self, action: #selector(onButtonClick(_:)), for: .touchUpInside)
            contentView.addSubview(button)
        }
        
        if let button2 = button2 {
            let button = Button(title: button2, style: button2Style ?? .secondary)
            button.tg_top.equal(12)
            button.tag = 2
            button.addTarget(self, action: #selector(onButtonClick(_:)), for: .touchUpInside)
            contentView.addSubview(button)
        }
    }
    
    @objc private func onButtonClick(_ sender: UIButton) {
        let tag = sender.tag
        if tag == 1 {
            action1?()
        } else if tag == 2 {
            action2?()
        }
    }
}
