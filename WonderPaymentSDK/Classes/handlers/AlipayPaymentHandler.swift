//
//  AlipayPaymentHandler.swift
//  PaymentSDK
//
//  Created by X on 2024/3/12.
//

import Foundation



class AlipayPaymentHandler : PaymentHander {
    
    enum SupportTransactionType {
        case autoDebitOnly
        case autoDebit
        case both
    }

    func isSupport(_ type: SupportTransactionType, intent: PaymentIntent) -> Bool {
        guard let entryTypes = intent.paymentMethod?.arguments?["entryTypes"] as? [String] else {
            return false
        }
        
        let entrySet = Set(entryTypes)
        
        switch type {
        case .autoDebitOnly:
            return entrySet.isSuperset(of: ["cit", "mit"]) && !entrySet.contains("in_app")
        case .autoDebit:
            return entrySet.isSuperset(of: ["cit", "mit"])
        case .both:
            return entrySet.isSuperset(of: ["cit", "mit", "in_app"])
        }
    }
    
    func preparePay(intent: PaymentIntent) -> Future<PaymentIntent?> {
        return Future<PaymentIntent?> { resolve, reject in
            //alipay大陆不支持免密支付
            if intent.paymentMethod?.type == .alipay {
                resolve(intent)
                return
            }
            
            let prepareToken = {
                _ = self.getToken().then { token in
                    guard let tokenString = token["token"].string else {
                        reject(ErrorMessage.argumentsError)
                        return
                    }
                    intent.paymentMethod?.arguments = ["token": tokenString]
                    resolve(intent)
                }
            }
            
            if isSupport(.autoDebitOnly, intent: intent){
                prepareToken()
            } else if isSupport(.both, intent: intent) {
                let doSelect = {
                    let amountText = "\(CurrencySymbols.get(intent.currency))\(formatAmount(intent.amount))"
                    let dialog = AutoDebitDialog(type: .alipayHK, amount: amountText)
                    dialog.show { result in
                        if result == 1 {
                            prepareToken()
                        } else if result == 2 {
                            resolve(intent)
                        } else {
                            resolve(nil)
                        }
                    }
                }
                
                getValidToken().then { token in
                    if let token {
                        guard let tokenString = token["token"].string else {
                            reject(ErrorMessage.argumentsError)
                            return
                        }
                        intent.paymentMethod?.arguments = ["token": tokenString]
                        resolve(intent)
                    } else {
                        doSelect()
                    }
                }
            } else {
                resolve(intent)
            }
        }
    }
    
    func pay(intent: PaymentIntent, delegate: PaymentDelegate) {
        preparePay(intent: intent.copy()).then { preparedInent in
            guard let preparedInent else { return }
            
            var payment_inst = "ALIPAYCN"
            if intent.paymentMethod?.type == .alipayHK {
                payment_inst = "ALIPAYHK"
            }
            
            if let token = preparedInent.paymentMethod?.arguments?["token"] as? String {
                preparedInent.paymentMethod?.arguments = [
                    "payment_token": [
                        "amount": "\(intent.amount)",
                        "token": token,
                    ]
                ]
            } else {
                preparedInent.paymentMethod?.arguments = [
                    "alipay": [
                        "amount": "\(intent.amount)",
                        "in_app": [
                            "app_env": "ios",
                            "payment_inst": payment_inst,
                        ]
                    ]
                ]
            }
            
            delegate.onProcessing()
            PaymentService.payOrder(intent: preparedInent) {
                result, error in
                if let transaction = result?.transaction
                {
                    let json = DynamicJson.from(transaction.acquirerResponseBody)
                    guard let paymentString = json["alipay"]["in_app"]["payinfo"].string else {
                        delegate.onFinished(intent: intent, result: result, error: .dataFormatError)
                        return
                    }
                    
                    delegate.onInterrupt(intent: intent)
                    
                    AlipaySDK.defaultService().payOrder(paymentString, fromScheme: WonderPayment.paymentConfig.fromScheme) {
                        data in
                        //WebView 回调
                        let resultStatus = data?["resultStatus"]
                        let memo = data?["memo"]
                        let callbackData: [String: Any?] = ["resultStatus": resultStatus, "memo": memo]
                        WonderPayment.alipayCallback?(callbackData)
                    }
                    
                    WonderPayment.alipayCallback = { data in
                        let resultStatus = data["resultStatus"] as? String
                        let memo = data["memo"] as? String
                        if resultStatus == "9000" {
                            let orderNum = intent.orderNumber
                            delegate.onProcessing()
                            PaymentService.loopForResult(uuid: transaction.uuid, orderNum: orderNum) {
                                result, error in
                                delegate.onFinished(intent: intent, result: result, error: error)
                            }
                        } else {
                            if resultStatus == "6001" {
                                delegate.onCanceled()
                            } else {
                                let error = ErrorMessage(code: "\(resultStatus ?? "")", message: memo ?? "")
                                delegate.onFinished(intent: intent, result: nil, error: error)
                            }
                        }
                    }
                    
                } else {
                    delegate.onFinished(intent: intent, result: result, error: error)
                }
            }
        }
    }
}

extension AlipayPaymentHandler {
    
    func getToken() -> Future<DynamicJson> {
        getValidToken().then { token in
            if let token {
                return Future<DynamicJson>.value(token)
            } else {
                return self.doAuthorization()
            }
        }
    }
    
    //获取可用token
    func getValidToken() -> Future<DynamicJson?> {
        Loading.show()
        return PaymentService.queryPaymentTokens().then {
            tokens in
            Loading.dismiss().map { _ in tokens }
        }.then {
            tokens in
            Loading.dismiss()
            let arr = tokens.filter({
                $0["token_type"].string == "AlipayAutoDebit" && $0["state"].string == "success"
            })
            return Future<DynamicJson?> { resolve, reject in
                let token = arr.isEmpty ? nil : arr.first
                resolve(token)
            }
        }.catch { error in
            Loading.dismiss()
            let err = error as? ErrorMessage ?? .unknownError
            Dialog.error(title: "unableProcess".i18n, message: "\(err.code)\n\(err.message)\n\("pleaseTryAgain".i18n)", button: "back".i18n)
        }
    }
    
    //签约
    func doAuthorization() -> Future<DynamicJson> {
        let args: NSDictionary = [
            "alipay": [
                "terminal_type": "WAP",
                "return_url": "\(WonderPayment.paymentConfig.fromScheme)://"
            ]
        ]
        Loading.show()
        //1.创建token
        return PaymentService.createPaymentToken(args: args).then { token in
            //2.跳转签约
            Loading.dismiss()
            guard let verifyUrl = token["verify_url"].string else {
                throw ErrorMessage.argumentsError
            }
            let browserController = BrowserViewController()
            browserController.modalPresentationStyle = .fullScreen
            browserController.url = verifyUrl
            UIViewController.current()?.present(browserController, animated: true)
            return Future<(DynamicJson, BrowserViewController)>.value((token, browserController))
        }.then { (token, browserController) in
            //3.获取签约参数，关闭webview
            return Future<(DynamicJson,String,String)> { resolve, reject in
                WonderPayment.alipayCallback = { data in
                    browserController.close()
                    guard let merchantAgreementId = data["merchantAgreementId"] as? String,
                          let authCode = data["authCode"] as? String else {
                        reject(ErrorMessage.argumentsError)
                        return
                    }
                    resolve((token, merchantAgreementId, authCode))
                }
            }
        }.then { (token,merchantAgreementId,authCode) in
            //4.传递authCode给后端完成签约
            Loading.show()
            return PaymentService.alipayAuthApply(
                merchantAgreementId: merchantAgreementId,
                authCode: authCode
            ).map { (token, $0) }
        }.then({ (token, applyResult) in
            //5.检查token是否有效，如果token.state不是success, 轮询检查3次
            return Future<DynamicJson> { resolve, reject in
                if applyResult["transaction"]["state"].string == "success" {
                    resolve(token)
                    return
                }
                
                guard let verifyUuid = token["verify_uuid"].string,
                      let tokenString = token["token"].string else {
                    reject(ErrorMessage.argumentsError)
                    return
                }
                
                self.checkTokenIfValid(uuid: verifyUuid, token:tokenString) { valid in
                    if valid {
                        resolve(token)
                    } else {
                        reject(ErrorMessage.unknownError)
                    }
                }
            }
        }).map { token in
            Loading.dismiss()
            return token
        } .catch { error in
            Loading.dismiss()
            let err = error as? ErrorMessage ?? .unknownError
            Dialog.error(title: "unableProcess".i18n, message: "\(err.code)\n\(err.message)", button: "back".i18n)
        }
    }
    
    func checkTokenIfValid(uuid: String, token: String, completion: @escaping (Bool) -> Void) {
        let maxAttempts = 3
        let timeout: TimeInterval = 30
        var attempt = 0
        var isFinished = false
        
        let timeoutWorkItem = DispatchWorkItem {
            if !isFinished {
                isFinished = true
                completion(false)
            }
        }
        
        // 设置30秒超时
        DispatchQueue.global().asyncAfter(deadline: .now() + timeout, execute: timeoutWorkItem)
        
        func attemptCheck() {
            guard !isFinished else { return }
            attempt += 1
            
            PaymentService.checkPaymentToken(uuid: uuid, token: token) { paymentToken, error in
                guard !isFinished else { return }
                
                if paymentToken?["state"].string == "success" {
                    isFinished = true
                    timeoutWorkItem.cancel()
                    completion(true)
                    return
                }
                
                if attempt >= maxAttempts {
                    isFinished = true
                    timeoutWorkItem.cancel()
                    completion(false)
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
