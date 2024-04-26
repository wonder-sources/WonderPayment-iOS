//
//  SvgImageView.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/4/26.
//

import SVGKit

class SvgImageView: SVGKFastImageView {
    
    convenience init(named: String) {
        if let url = resBundle?.url(forResource: named, withExtension: "svg"),
           let svgImage = SVGKImage.init(contentsOf: url) {
            self.init(svgkImage: svgImage)
        } else {
            self.init(frame: .zero)
        }
    }
}

