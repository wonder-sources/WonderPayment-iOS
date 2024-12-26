//
//  CallbackAction.swift
//  Pods
//
//  Created by X on 2024/12/26.
//

class CallbackAction {
    let onInvoke: (String, Any?) -> Any?
    
    init(onInvoke: @escaping (String, Any?) -> Any?) {
        self.onInvoke = onInvoke
    }
    
    func invoke(method: String, arguments: Any?) -> Any? {
        return onInvoke(method, arguments)
    }
}
