//
//  ErrorPage.swift
//  Pods
//
//  Created by X on 2024/12/26.
//

import Lottie
import QMUIKit
import TangramKit

class ErrorPage {

    
    private static var modalViewController: QMUIModalPresentationViewController?
    
    static func show(error: ErrorMessage, onRetry: VoidCallback? = nil) {
        
        func waitDismiss(completion: @escaping VoidCallback) {
            if modalViewController == nil {
                completion()
            } else {
                dismiss(animated: false) { _ in
                    completion()
                }
            }
        }
        
        let callbackAction = CallbackAction { method, _ in
            dismiss()
            if (method == "retry") {
                onRetry?()
            }
            return nil
        }
        
        waitDismiss {
            let contentView = ContentView(error: error, callbackAction: callbackAction)
            modalViewController = QMUIModalPresentationViewController()
            modalViewController?.contentViewMargins = UIEdgeInsets.zero
            modalViewController?.contentView = contentView
            modalViewController?.isModal = true
            modalViewController?.showWith(animated: true)
        }
    }
    
    static func dismiss(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        if modalViewController == nil {
            completion?(true)
            return
        }
        modalViewController?.hideWith(animated: animated) { completed in
            modalViewController = nil
            completion?(completed)
        }
    }
    
    class ContentView: TGRelativeLayout {
        
        var error: ErrorMessage
        var callbackAction: CallbackAction?
        
        init(error: ErrorMessage, callbackAction: CallbackAction? = nil) {
            self.error = error
            self.callbackAction = callbackAction
            super.init(frame: .zero)
            self.initView()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        lazy var titleLabel = Label("unableProcess".i18n,color: WonderPayment.uiConfig.errorColor, size: 18, fontStyle: .bold)
        lazy var errorCodeLabel = Label(error.code,color: WonderPayment.uiConfig.primaryTextColor, size: 18, fontStyle: .normal)
        lazy var errorMsgLabel = Label(error.message,color: WonderPayment.uiConfig.primaryTextColor, size: 18, fontStyle: .normal)
        lazy var retryButton = Button(title:"tryAgain".i18n, style: .primary)
        lazy var exitButton = Button(title:"exit".i18n, style: .secondary)
        
        private func initView() {
            self.tg_width.equal(.fill)
            self.tg_height.equal(.fill)
            self.backgroundColor = WonderPayment.uiConfig.background
            
            let contentLayout = TGLinearLayout(.vert)
            contentLayout.tg_width.equal(.fill)
            contentLayout.tg_height.equal(.wrap)
            contentLayout.tg_centerY.equal(0)
            addSubview(contentLayout)
            
            let icon = UIImageView(image: "error2".svg)
            icon.tg_width.equal(56)
            icon.tg_height.equal(56)
            icon.tg_centerX.equal(0)
            contentLayout.addSubview(icon)
            
            titleLabel.tg_top.equal(8)
            titleLabel.tg_centerX.equal(0)
            contentLayout.addSubview(titleLabel)
            
            errorCodeLabel.tg_top.equal(8)
            errorCodeLabel.tg_centerX.equal(0)
            contentLayout.addSubview(errorCodeLabel)
            
            errorMsgLabel.tg_centerX.equal(0)
            errorMsgLabel.tg_left.equal(48)
            errorMsgLabel.tg_right.equal(48)
            errorMsgLabel.textAlignment = .center
            errorMsgLabel.numberOfLines = 5
            contentLayout.addSubview(errorMsgLabel)
            
            retryButton.tg_top.equal(24)
            retryButton.tg_left.equal(48)
            retryButton.tg_right.equal(48)
            retryButton.addTarget(self, action: #selector(retry(_:)), for: .touchUpInside)
            contentLayout.addSubview(retryButton)
            
            exitButton.tg_top.equal(18)
            exitButton.tg_left.equal(48)
            exitButton.tg_right.equal(48)
            exitButton.addTarget(self, action: #selector(exit(_:)), for: .touchUpInside)
            contentLayout.addSubview(exitButton)
        }
        
        @objc func retry(_ sender: UIView) {
            _ = callbackAction?.invoke(method: "retry", arguments: nil)
        }
        
        @objc func exit(_ sender: UIView) {
            _ = callbackAction?.invoke(method: "exit", arguments: nil)
        }
    }
}
