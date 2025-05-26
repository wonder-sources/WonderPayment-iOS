import SVGKit

extension UIImage {
    static func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

extension String {
    
    var svg: UIImage? {
        get {
            if let url = resBundle?.url(forResource: self, withExtension: "svg")
            {
                let svgImage = SVGKImage.init(contentsOf: url)
                
                return svgImage?.uiImage
            }
            return nil
        }
    }
    
    var png: UIImage? {
        get {
            if let file = resBundle?.path(forResource: self, ofType: "png")
            {
                let image = UIImage(contentsOfFile: file)
                return image
            }
            return nil
        }
    }
    
    func svgWith(tintColor: UIColor?) -> UIImage? {
        if let url = resBundle?.url(forResource: self, withExtension: "svg")
        {
            let svgImage = SVGKImage.init(contentsOf: url)
            if let tintColor {
                svgImage?.fillColor(color: tintColor, opacity: 1.0)
            }
            return svgImage?.uiImage
        }
        return nil
    }
}

extension SVGKImage {
    func fillColor(color: UIColor, opacity: Float) {
        func applyFillColor(to layer: CALayer) {
            if let shapeLayer = layer as? CAShapeLayer {
                shapeLayer.fillColor = color.cgColor
                shapeLayer.opacity = opacity
            }
            layer.sublayers?.forEach { applyFillColor(to: $0) }
        }
        applyFillColor(to: self.caLayerTree)
    }
}

