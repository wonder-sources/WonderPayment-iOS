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

extension Optional where Wrapped == NSDictionary {
    mutating func ensureAndAppend(key: NSCopying, value: Any) {
        let mutable: NSMutableDictionary
        if let existing = self as? NSMutableDictionary {
            mutable = existing
        } else {
            mutable = NSMutableDictionary(dictionary: self ?? [:])
        }
        mutable[key] = value
        self = mutable
    }
    
    mutating func ensureAndAppend(contentsOf newDict: NSDictionary) {
        let mutable: NSMutableDictionary
        if let existing = self as? NSMutableDictionary {
            mutable = existing
        } else {
            mutable = NSMutableDictionary(dictionary: self ?? [:])
        }
        mutable.addEntries(from: newDict as! [AnyHashable: Any])
        self = mutable
    }
    
    mutating func ensureAndAppend<K, V>(contentsOf swiftDict: [K: V]) {
        let mutable: NSMutableDictionary
        if let existing = self as? NSMutableDictionary {
            mutable = existing
        } else {
            mutable = NSMutableDictionary(dictionary: self ?? [:])
        }
        for (k, v) in swiftDict {
            guard let key = k as? NSCopying else { continue }
            mutable[key] = v
        }
        self = mutable
    }
}


