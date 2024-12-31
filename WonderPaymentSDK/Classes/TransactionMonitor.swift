//
//  TransactionMonitor.swift
//  Pods
//
//  Created by X on 2024/12/31.
//

class TransactionMonitor {
    
    static var eventTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Foundation.Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: Date())
    }
    
    static func monitorTransaction(_ transaction: Transaction) {
        var level: String?
        var message: String?
        if transaction.amount > 50000 {
            level = "Red"
            message = "Transaction amount is over 5w"
        } else if (transaction.amount > 10000) {
            level = "Orange"
            message = "Transaction amount is over 1w"
        } else if (transaction.amount > 5000) {
            level = "Gray"
            message = "Transaction amount is over 0.5w"
        }
        guard let level, let message else {
            return
        }
        let type = "Payment Collect Amount Warning"
        let data: NSDictionary = [
            "device": deviceId,
            "type": type,
            "level": level,
            "content": [
                type: message,
                "Transaction Amount": transaction.amount,
                "From": "Payment SDK iOS",
                "App Id": WonderPayment.paymentConfig.appId,
                "Customer Id": WonderPayment.paymentConfig.customerId,
            ],
            "appear_time": eventTime,
        ]
        
        GatewayService.reportEvent(data)
    }
}
