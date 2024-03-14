//
//  UIViewControllerExt.swift
//  PaymentSDK
//
//  Created by X on 2024/3/11.
//

import Foundation

extension UIViewController {
    class func current(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return current(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return current(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return current(base: presented)
        }
        return base
    }
}
