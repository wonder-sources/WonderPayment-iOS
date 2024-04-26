import TangramKit
import SVGKit

class BanksView : TGLinearLayout {
    

    convenience init(spacing: CGFloat = 2) {
        self.init(frame: .zero, orientation: .horz)
        self.tg_space = spacing
        self.initView()
    }
    
    
    private func initView() {
        self.tg_width.equal(.wrap)
        self.tg_height.equal(.wrap)
        addSubview(createCardIcon("Visa"))
        addSubview(createCardIcon("MasterCard", height: 23))
        addSubview(createCardIcon("AmericanExpress", width: 33, height: 21))
        addSubview(createCardIcon("ChinaUnion"))
        addSubview(createCardIcon("JCB"))
        addSubview(createCardIcon("Discover"))
        addSubview(createCardIcon("DinersClub"))
    }
    
    private func createCardIcon(_ icon: String, width: Int = 26, height: Int = 24) -> UIView {
        let imageView = UIImageView()
        imageView.tg_width.equal(width)
        imageView.tg_height.equal(height)
        imageView.tg_centerY.equal(0)
        if let url = resBundle?.url(forResource: "\(icon)_26", withExtension: "png"),
           let image = try? UIImage(data: Data(contentsOf: url)) {
            imageView.image = image
        }
        return imageView
    }
}
