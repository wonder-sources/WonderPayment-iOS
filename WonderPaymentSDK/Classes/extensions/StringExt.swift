//
//  StringExt.swift
//  PaymentSDK
//
//  Created by X on 2024/3/9.
//

import Foundation
import CommonCrypto

extension String {
    
    var isNotEmpty: Bool { !isEmpty }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func replace(_ target:String, with:String) -> String {
        return self.replacingOccurrences(of: target, with: with)
    }
}

extension String {
    
    var md5: String {
        if let data = self.data(using: .utf8) {
            // Create an array of unsigned 8-bit integers, initialized with zeros
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            
            // Calculate MD5 hash
            _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> String in
                _ = CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
                
                return digest.map { String(format: "%02hhx", $0) }.joined()
            }
            
            return digest.map { String(format: "%02hhx", $0) }.joined()
        }
        
        return ""
    }
    
}
