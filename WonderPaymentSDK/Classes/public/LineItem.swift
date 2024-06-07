//
//  LineItem.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/4/11.
//

import Foundation

public class LineItem {
    public var purchasableType: String
    public var purchaseId: Int?
    public var quantity: Int
    public var price: Double
    public var total: Double
    
    public init(
        purchasableType: String,
        purchaseId: Int? = nil,
        quantity: Int,
        price: Double,
        total: Double
    ) {
        self.purchasableType = purchasableType
        self.purchaseId = purchaseId
        self.quantity = quantity
        self.price = price
        self.total = total
    }
    
    public func copy() -> LineItem {
        return LineItem(
            purchasableType: self.purchasableType, 
            purchaseId: self.purchaseId,
            quantity: self.quantity,
            price: self.price,
            total: self.total
        )
    }
}

//public enum PurchasableType: String {
//    case charge = "Charge"
//}

extension LineItem: JSONEncodable, JSONDecodable {
    
    func toJson() -> Dictionary<String, Any?> {
        return [
            "purchasable_type": purchasableType,
            "purchase_id": purchaseId,
            "price": price,
            "quantity": quantity,
            "total": total
        ]
    }
    
    static func from(json: NSDictionary?) -> Self {
        return LineItem(
            purchasableType: json?["purchasable_type"] as? String ?? "",
            purchaseId: json?["purchase_id"] as? Int,
            quantity: json?["quantity"] as? Int ?? 0,
            price: json?["price"] as? Double ?? 0,
            total: json?["total"] as? Double ?? 0
        ) as! Self
    }
    
    
}
