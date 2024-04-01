//
//  JSONEncodable.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/4/1.
//

import Foundation

protocol JSONEncodable: CustomStringConvertible {
    func toJson() -> Dictionary<String, Any?>
    
    func toJsonString() -> String
}

extension JSONEncodable {
    public var description: String {
        return toJsonString()
    }
    
    func toJsonString() -> String {
        if  let jsonData = try? JSONSerialization.data(withJSONObject: self.toJson(), options: .prettyPrinted) {
            return String(decoding: jsonData, as: UTF8.self)
        }
        return "{}"
    }
}
