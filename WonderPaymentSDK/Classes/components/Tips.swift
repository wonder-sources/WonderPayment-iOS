//
//  Tips.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/3/20.
//

import Foundation
import QMUIKit
import TangramKit


class Tips {
    
    enum TipsStyle {
        case normal, error
    }
    
    static var tipsController: QMUIModalPresentationViewController?
    
    static func show(
        style: TipsStyle = .normal,
        image:UIImage? = nil,
        title: String? = nil,
        subTitle: String? = nil,
        completion: ((Bool) -> Void)? = nil
    ) {
        dismiss()
        let tipsView = TipsView(image: image, title: title, subTitle: subTitle, style: style)
        tipsController = QMUIModalPresentationViewController()
        tipsController?.contentViewMargins = UIEdgeInsets.zero
        tipsController?.contentView = tipsView
        tipsController?.isModal = true
        tipsController?.showWith(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss(completion: completion)
        }
    }
    
    static func dismiss(completion: ((Bool) -> Void)? = nil) {
        tipsController?.hideWith(animated: true) { finished in
            tipsController = nil
            completion?(finished)
        }
    }
}

class TipsView : UIView {
    
    var image: UIImage?
    var title: String?
    var subTitle: String?
    var style: Tips.TipsStyle = .normal
    
    convenience init(image:UIImage? = nil, title: String? = nil, subTitle: String? = nil, style: Tips.TipsStyle = .normal) {
        self.init(frame: .zero)
        self.image = image
        self.title = title
        self.subTitle = subTitle
        self.style = style
        initView()
    }
    
    private func initView() {
        self.tg_width.equal(.wrap)
        self.tg_height.equal(.wrap)
        
        let contentView = TGLinearLayout(.vert)
        contentView.tg_width.equal(268)
        contentView.tg_height.equal(.wrap)
        contentView.tg_padding = UIEdgeInsets(top: 24, left: 32, bottom: 24, right: 32)
        contentView.backgroundColor = WonderPayment.uiConfig.background
        contentView.layer.cornerRadius = 12
        addSubview(contentView)
        
        let imageView = UIImageView()
        imageView.image = image ?? (style == .error ? "error2".svg : nil)
        imageView.tg_width.equal(.wrap)
        imageView.tg_height.equal(.wrap)
        imageView.tg_centerX.equal(0)
        contentView.addSubview(imageView)
        
        let titleLabel: UILabel
        if style == .normal {
            titleLabel = Label(title ?? "", size: 16, fontStyle: .medium)
        } else {
            titleLabel = Label(title ?? "", color: WonderPayment.uiConfig.errorColor, size: 14)
        }
        
        titleLabel.tg_width.equal(.fill)
        titleLabel.tg_height.equal(.wrap)
        titleLabel.textAlignment = .center
        titleLabel.tg_top.equal(16)
        contentView.addSubview(titleLabel)
        
        let subTitleLabel: UILabel
        if style == .normal {
            subTitleLabel = Label(subTitle ?? "", style: .secondary, size: 14)
        } else {
            subTitleLabel = Label(subTitle ?? "", color: WonderPayment.uiConfig.errorColor, size: 14)
        }
        
        subTitleLabel.tg_top.equal(6)
        subTitleLabel.tg_width.equal(.fill)
        subTitleLabel.tg_height.equal(.wrap)
        subTitleLabel.textAlignment = .center
        contentView.addSubview(subTitleLabel)
    }
}
