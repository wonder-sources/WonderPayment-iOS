//
//  FlutterPatch.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/9/3.
//

import Foundation
import ObjectiveC.runtime

// 修复FlutterSecureTextInputView Debug时闪退问题
class FlutterPatch {
    @objc func attributedText() -> String {
        return ""
    }
    
    @objc func setAttributedText(_ text: String) {
    }

    // 使用 Runtime 给 FlutterSecureTextInputView 动态添加方法
    func addAttributedText() {
        guard let cls = NSClassFromString("FlutterSecureTextInputView") else {
            return
        }

        let method1 = class_getInstanceMethod(type(of: self), #selector(attributedText))
        let method2 = class_getInstanceMethod(type(of: self), #selector(setAttributedText(_:)))
        
        // 添加方法到 FlutterSecureTextInputView 类
        class_addMethod(cls, #selector(attributedText), method_getImplementation(method1!), method_getTypeEncoding(method1!))
        
        class_addMethod(cls, #selector(setAttributedText(_:)), method_getImplementation(method2!), method_getTypeEncoding(method2!))
    }
    
    static func patch() {
        FlutterPatch().addAttributedText()
    }
}
