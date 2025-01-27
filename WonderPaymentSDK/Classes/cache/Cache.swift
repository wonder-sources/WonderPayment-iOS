//
//  Cache.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/5/28.
//

import Foundation

typealias CacheListener = (Any?) -> Void
class Cache {
    private static var storage: [AnyHashable: Any?] = [:]
    private static var listeners: [AnyHashable: [CacheListener]] = [:]
    
    static func get<T>(for key: AnyHashable) -> T? {
        return storage[key] as? T
    }
    
    static func set(_ value: Any?, for key: AnyHashable) {
        storage[key] = value
        listeners[key]?.forEach({ listener in
            listener(value)
        })
    }
    
    static func addListener(for key: AnyHashable, listener: @escaping CacheListener) {
        if listeners[key] != nil{
            listeners[key]!.append(listener)
        } else {
            listeners[key] = [listener]
        }
    }
    
    static func removeListener(for key: AnyHashable) {
        listeners.removeValue(forKey: key)
    }
    
    static func dispose() {
        storage.removeAll()
        listeners.removeAll()
    }
}
