//
//  PlaceholderView.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/7/12.
//

import Foundation

class PlaceholderView : UIView {
    
    init(
        backgroundColor: UIColor = UIColor(hexString: "FFF5F7F9"),
        cornerRadius: CGFloat = WonderPayment.uiConfig.borderRadius
    ) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        self.tg_layoutCompletedDo { 
            [unowned self] layout, view in
            let shimmerLayer = CAGradientLayer()
            shimmerLayer.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.2).cgColor, UIColor.clear.cgColor]
            shimmerLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            shimmerLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            shimmerLayer.frame = CGRect(x: -bounds.width, y: 0, width: 3 * bounds.width, height: bounds.height)
            shimmerLayer.locations = [0.0, 0.5, 1.0]
            
            layer.addSublayer(shimmerLayer)
            
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.fromValue = -bounds.width * 0.5
            animation.toValue = bounds.width
            animation.duration = 1.5
            animation.repeatCount = .infinity
            
            shimmerLayer.add(animation, forKey: "shimmer")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit")
    }

}
