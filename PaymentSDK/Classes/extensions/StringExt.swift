//
//  StringExt.swift
//  PaymentSDK
//
//  Created by X on 2024/3/9.
//

import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func replace(_ target:String, with:String) -> String {
        return self.replacingOccurrences(of: target, with: with)
    }
}
