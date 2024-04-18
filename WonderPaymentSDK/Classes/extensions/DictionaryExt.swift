//
//  DictionaryExt.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/4/12.
//

import Foundation

extension Dictionary {
    func merge(_ another: NSDictionary?) -> NSDictionary {
        let result = NSMutableDictionary(dictionary: self)
        if let another = another {
            for entry in another {
                result[entry.key] = entry.value
            }
        }
        return result
    }
}

extension NSDictionary {
    func merge(_ another: NSDictionary?) -> NSDictionary {
        let result = NSMutableDictionary(dictionary: self)
        if let another = another {
            for entry in another {
                result[entry.key] = entry.value
            }
        }
        return result
    }
}
