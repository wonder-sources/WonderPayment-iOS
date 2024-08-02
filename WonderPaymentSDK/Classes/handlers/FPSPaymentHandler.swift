//
//  FPSPaymentHandler.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/7/15.
//

import Foundation

class FPSPaymentHandler : PaymentHander {
    
    func pay(intent: PaymentIntent, delegate: PaymentDelegate) {
        delegate.onProcessing()
        
        intent.paymentMethod?.arguments = [
            "fps": [
                "amount": "\(intent.amount)",
                "in_app":[:],
            ]
        ]
        
        PaymentService.payOrder(intent: intent) {
            result, error in
            if let transaction = result?.transaction
            {
                let json = DynamicJson.from(transaction.acquirerResponseBody)
                guard let payload = json["fps"]["in_app"]["payinfo"].string else {
                    delegate.onFinished(intent: intent, result: result, error: .dataFormatError)
                    return
                }
                
                Loading.dismiss() { _ in
                    delegate.onInterrupt(intent: intent)
                    
                    guard let viewController = UIViewController.current() else {
                        delegate.onFinished(intent: intent, result: result, error: .unknownError)
                        return
                    }
                    
                    let item = NSExtensionItem()
                    let scheme = WonderPayment.paymentConfig.fromScheme
                    let paymentString = "https://fps.wonder.today/fps?payload=\(payload.base64)"
                    let itemProvider = NSItemProvider(
                        item: ["URL": paymentString, "callback": "\(scheme)://fps"] as NSSecureCoding,
                        typeIdentifier: "hk.com.hkicl"
                    )
                    item.attachments = [itemProvider]
                    
//                    let item = FpsItemSource(paymentURL: URL(string: paymentString)!)
                    
                    // 调用 app chooser 让用户选择支付应用
                    let selectController = UIActivityViewController(activityItems: [item], applicationActivities: nil)
                    selectController.excludedActivityTypes = [.airDrop, .message,.copyToPasteboard, .addToReadingList, ]
                    
                    // 处理支付完成后的回调
                    selectController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
                        if completed {
                            WonderPayment.fpsCallback = { _ in
                                let orderNum = intent.orderNumber
                                delegate.onProcessing()
                                PaymentService.loopForResult(uuid: transaction.uuid, orderNum: orderNum) {
                                    result, error in
                                    delegate.onFinished(intent: intent, result: result, error: error)
                                }
                            }
                        } else {
                            delegate.onCanceled()
                        }
                    }
                    
                    viewController.present(selectController, animated: true, completion: nil)
                }
                
            } else {
                delegate.onFinished(intent: intent, result: result, error: error)
            }
        }
    }
    
}


class FpsItemSource: NSObject, UIActivityItemSource {
    let paymentURL: URL
    
    init(paymentURL: URL) {
        self.paymentURL = paymentURL
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return paymentURL
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return nil
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, dataTypeIdentifierForActivityType activityType: UIActivity.ActivityType?) -> String {
        return "hk.com.hkicl"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, thumbnailImageForActivityType activityType: UIActivity.ActivityType?, suggestedSize size: CGSize) -> UIImage? {
        return nil
    }
}
