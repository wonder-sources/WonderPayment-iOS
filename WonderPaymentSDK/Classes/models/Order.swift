//
//  OrderModel.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/4/12.
//

import Foundation

struct Order : JSONDecodable {
    let source: String
    let type: String
    let number: String
    let dueDate: String
    let referenceNumber: String
    let initialTotal: Double
    let initialTips: Double
    let subtotal: Double
    let state: String
    let correspondenceState: String
    let currency: String
    let note: String
    let authCode: String
    let lineItems: [LineItem]?
    let transactions: [Transaction]?
    
    static func from(json: NSDictionary?) -> Order {
        let source = json?["source"] as? String ?? ""
        let type = json?["type"] as? String ?? ""
        let number = json?["number"] as? String ?? ""
        let dueDate = json?["due_date"] as? String ?? ""
        let referenceNumber = json?["reference_number"] as? String ?? ""
        let initialTotal = json?["initial_total"] as? Double ?? 0
        let initialTips = json?["initial_tips"] as? Double ?? 0
        let subtotal = json?["subtotal"] as? Double ?? 0
        let state = json?["state"] as? String ?? ""
        let correspondenceState = json?["correspondence_state"] as? String ?? ""
        let currency = json?["currency"] as? String ?? ""
        let note = json?["note"] as? String ?? ""
        let authCode = json?["authCode"] as? String ?? ""
        let lineItems = LineItem.from(jsonArray: json?["line_items"] as? NSArray)
        let transactions = Transaction.from(jsonArray: json?["transactions"] as? NSArray)
        
        return Order(source: source, type: type, number: number, dueDate: dueDate, referenceNumber: referenceNumber, initialTotal: initialTotal, initialTips: initialTips, subtotal: subtotal, state: state, correspondenceState: correspondenceState, currency: currency, note: note, authCode: authCode, lineItems: lineItems, transactions: transactions)
    }
}
