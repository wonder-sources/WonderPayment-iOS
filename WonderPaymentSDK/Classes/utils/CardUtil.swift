//
//  CardUtil.swift
//  Pods
//
//  Created by X on 2025/5/9.
//

class CardUtil {
    static func bindCard(
        _ args: [String: Any],
        showLoading: Bool = true,
        showTips: Bool = true,
        completion: ((CreditCardInfo?, ErrorMessage?) -> Void)? = nil)
    {
        if showLoading {
            Loading.show()
        }
        PaymentService.bindCard(cardInfo: args as NSDictionary) { card, error in
            Loading.dismiss() { _ in
                guard let card else {
                    completion?(nil, error)
                    if showTips {
                        Tips.show(style: .error, title: error?.code, subTitle: error?.message)
                    }
                    return
                }
                
                checkIfValid(card, showLoading: showLoading) { validCard,error in
                    guard let validCard else {
                        completion?(nil, error)
                        if showTips {
                            Tips.show(style: .error, title: error?.code, subTitle: error?.message)
                        }
                        return
                    }
                    completion?(validCard, nil)
                }
            }
        }
    }
    
    static func checkIfValid(
        _ card: CreditCardInfo,
        showLoading: Bool = true,
        callback: @escaping (CreditCardInfo?, ErrorMessage?) -> Void)
    {
        if card.state == "success" {
            callback(card, nil)
        } else if card.state == "pending" {
            if let _3dsUrl = card.verifyUrl {
                let browserController = BrowserViewController()
                browserController.modalPresentationStyle = .fullScreen
                browserController.url = _3dsUrl
                browserController.finishedCallback = { result in
                    guard let succeed = result as? Bool, succeed else {
                        callback(nil, ErrorMessage._3dsVerificationError)
                        return
                    }
                    if showLoading {
                        Loading.show()
                    }
                    checkPaymentTokenIsValid(card) { cardInfo, error in
                        Loading.dismiss { _ in callback(cardInfo, error) }
                    }
                }
                topViewController?.present(browserController, animated: true)
            } else {
                if showLoading {
                    Loading.show()
                }
                self.checkPaymentTokenIsValid(card) { cardInfo, error in
                    Loading.dismiss { _ in callback(cardInfo, error) }
                }
            }
        } else {
            callback(nil, ErrorMessage.bindCardError)
        }
    }
    
    static func checkPaymentTokenIsValid(_ card: CreditCardInfo, callback: @escaping (CreditCardInfo?, ErrorMessage?) -> Void) {
        guard let uuid = card.verifyUuid, let token = card.token else {
            callback(nil, ErrorMessage.argumentsError)
            return
        }
        
        let maxAttempts = 20
        let timeout: TimeInterval = 30
        var attempt = 0
        var isFinished = false
        
        let timeoutWorkItem = DispatchWorkItem {
            if !isFinished {
                isFinished = true
                callback(nil, ErrorMessage.bindCardError)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout, execute: timeoutWorkItem)
        
        func attemptCheck() {
            guard !isFinished else { return }
            attempt += 1
            
            PaymentService.checkPaymentToken(uuid: uuid, token: token) { paymentToken, err in
                let state = paymentToken?["state"].string
                if  state == "success" {
                    isFinished = true
                    timeoutWorkItem.cancel()
                    let cardInfo = CreditCardInfo.from(json: paymentToken?.value as? NSDictionary)
                    callback(cardInfo, nil)
                    return
                } else if state == "failed" {
                    isFinished = true
                    timeoutWorkItem.cancel()
                    callback(nil, ErrorMessage.bindCardError)
                    return
                }
                
                if attempt >= maxAttempts {
                    isFinished = true
                    timeoutWorkItem.cancel()
                    callback(nil, ErrorMessage.bindCardError)
                    return
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    attemptCheck()
                }
            }
        }
        
        attemptCheck()
    }
}
