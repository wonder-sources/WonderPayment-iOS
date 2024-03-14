import TangramKit

class BanksView : TGLinearLayout {
    
    var spacing: Int = 2
    
    convenience init(spacing: Int = 2) {
        self.init(frame: .zero, orientation: .horz)
        self.spacing = spacing
        self.initView()
    }
    
    
    private func initView() {
        self.tg_width.equal(.wrap)
        self.tg_height.equal(.wrap)
        addSubview(createCardIcon("Visa", spacing: 3))
        addSubview(createCardIcon("MasterCard"))
        addSubview(createCardIcon("AmericanExpress"))
        addSubview(createCardIcon("ChinaUnion"))
        addSubview(createCardIcon("JCB"))
        addSubview(createCardIcon("Discover"))
        addSubview(createCardIcon("DinersClub"))
    }
    
    private func createCardIcon(_ icon: String, spacing: CGFloat = 0) -> UIView {
        let container = TGLinearLayout(.horz)
        container.tg_width.equal(26)
        container.tg_height.equal(24)
        container.tg_left.equal(self.spacing)
        container.tg_right.equal(spacing)
        container.tg_centerY.equal(0)
        
        let imageView = UIImageView(image: icon.svg)
        imageView.tg_width.equal(.wrap)
        imageView.tg_height.equal(.wrap)
        imageView.tg_centerY.equal(0)
        imageView.tg_centerX.equal(0)
        imageView.contentMode = .scaleAspectFit
        container.addSubview(imageView)
        
        return container
    }
}
