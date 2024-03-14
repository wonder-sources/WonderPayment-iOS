import SVGKit

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
}
