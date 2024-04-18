//
//  MethodPreviewController.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/4/15.
//

import Foundation

protocol MethodPreviewDelegate {
    func tokenDeleted(token: String)
}

class MethodPreviewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let isDark = WonderPayment.uiConfig.background.qmui_colorIsDark
        if #available(iOS 13.0, *) {
            return isDark ? .lightContent : .darkContent
        } else {
            return isDark ? .lightContent : .default
        }
    }
    
    let paymentMethod: PaymentMethod
    let delegate: MethodPreviewDelegate?
    
    init(method: PaymentMethod, delegate: MethodPreviewDelegate? = nil) {
        self.paymentMethod = method
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var mView = MethodPreviewView(method: paymentMethod)
    
    override func loadView() {
        view = mView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mView.titleBar.leftView.addTarget(self, action: #selector(back), for: .touchUpInside)
        mView.cardView?.deleteButton.addTarget(self, action: #selector(deleteCard), for: .touchUpInside)
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteCard() {
        Dialog.confirm(icon: "warning".svg, title: "deleteCard".i18n, message: "sureDeleteThisCard".i18n, button1: "back".i18n, button2: "deleteThisCard".i18n, button2Style: .warning, action2: {
            [weak self] dialogController in
            dialogController.hideWith(animated: true)
            guard let token = self?.paymentMethod.arguments?["token"] as? String else {
                return
            }
            Loading.show()
            PaymentService.deletePaymentToken(token: token) { succeed, error in
                Loading.dismiss()
                if let error = error {
                    Tips.show(style: .error, title: error.code, subTitle: error.message)
                    return
                }
                self?.delegate?.tokenDeleted(token: token)
                self?.navigationController?.popViewController(animated: true)
                Tips.show(image: "deleted".svg, title: "cardDeleted".i18n, subTitle: "cardDeletedSuccess".i18n)
            }
        })
        
    }
}
