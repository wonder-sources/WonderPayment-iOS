//
//  TransactionModel.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/4/12.
//

import Foundation

struct Transaction : JSONDecodable {
    let type: String
    let source: String
    let success: Bool
    let isPending: Bool
    let uuid: String
    let acquirerResponseBody: String
    let currency: String
    let amount: Double
    let paymentMethod: String
    let paymentData: Any?
    let createdAt: String
    let _3ds: _3ds?
    
    static func from(json: NSDictionary?) -> Self {
        let type = json?["type"] as? String ?? ""
        let source = json?["source"] as? String ?? ""
        let success = json?["success"] as? Bool ?? false
        let isPending = json?["is_pending"] as? Bool ?? true
        let uuid = json?["uuid"] as? String ?? ""
        let acquirerResponseBody = json?["acquirer_response_body"] as? String ?? ""
        let currency = json?["currency"] as? String ?? ""
        let amount = json?["amount"] as? Double ?? 0
        let paymentMethod = json?["payment_method"] as? String ?? ""
        let paymentData = json?["payment_data"]
        let createdAt = json?["created_at"] as? String ?? ""
        let _3ds = Transaction._3ds.from(json: json?["3ds"] as? NSDictionary)
        
        return Transaction(type: type, source: source, success: success, isPending: isPending, uuid: uuid, acquirerResponseBody: acquirerResponseBody, currency: currency, amount: amount, paymentMethod: paymentMethod, paymentData: paymentData, createdAt: createdAt, _3ds: _3ds)
    }
    
    struct _3ds : JSONDecodable {
        let enrolled: String?
        let redirectUrl: String?
        
        static func from(json: NSDictionary?) -> Transaction._3ds {
            let enrolled = json?["enrolled"] as? String
            let redirectUrl = json?["redirect_url"] as? String
            return _3ds(enrolled: enrolled, redirectUrl: redirectUrl)
        }
    }
}
