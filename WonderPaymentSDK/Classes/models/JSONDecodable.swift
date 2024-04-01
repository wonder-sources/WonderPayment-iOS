//
//  JSONDecodable.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/4/1.
//

protocol JSONDecodable {
    static func from(json: NSDictionary?) -> Self
}

extension JSONDecodable {
    static func from(jsonArray: NSArray?) -> Array<Self> {
        var array: [Self] = []
        for item in jsonArray ?? [] {
            if let json = item as? NSDictionary {
                array.append(self.from(json: json))
            }
        }
        return array
    }
}


