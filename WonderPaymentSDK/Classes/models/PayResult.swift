struct PayResult: JSONDecodable {  // <-- here
//    let createdAt: String?
//    let success: Bool?
//    let amount: Double?
//    let extra: Any?
//    let referenceId: String?
//    let payment: Any?
//    let ds3: Any?
//    let currency: String?
//    let uuid: String?
//    let isPending: Bool?
//    let acquirerResponseBody: String?
//    let paymentData: Any?
//    let transactionInfo: Any?
    
    let order: Order
    var transaction: Transaction?
    

    static func from(json: NSDictionary?) -> PayResult {
//        let success = json?["success"] as? Bool
//        let allowVoid = json?["allow_void"] as? Bool
//        let extra = json?["extra"]
//        let amount = json?["amount"] as? Double
//        let voidIsPending = json?["void_is_pending"] as? Bool
//        let refundedAmount = json?["refunded_amount"] as? Double
//        let currency = json?["currency"] as? String
//        let allowRefund = json?["allow_refund"] as? Bool
//        let uuid = json?["uuid"] as? String
//        let paymentData = json?["payment_data"]
//        let paymentMethod = json?["payment_method"] as? Int
//        let id = json?["id"] as? Int
//        let payment = json?["payment"] as? String
//        let tipsAmount = json?["tips_amount"] as? Double
//        let voidedAt = json?["voided_at"] as? String
//        let from = json?["from"] as? Int
//        let note = json?["note"] as? String
//        let referenceId = json?["reference_id"] as? String
//        let createdAt = json?["created_at"] as? String
//        let ds3 = json?["3ds"]
//        let captured = json?["captured"] as? Bool
//        let acquirerResponseBody = json?["acquirer_response_body"] as? String
//        let isPending = json?["is_pending"] as? Bool
//        let transactionInfo = json?["transactionInfo"]
//        
//        return PayResult(createdAt: createdAt, success: success, amount: amount, extra: extra, referenceId: referenceId, payment: payment, ds3: ds3, currency: currency, uuid: uuid, isPending: isPending, acquirerResponseBody: acquirerResponseBody, paymentData: paymentData, transactionInfo: transactionInfo)
        let order = Order.from(json: json?["order"] as? NSDictionary)
        return PayResult(order: order)
    }
    
}
