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
        let items = ["visa", "mastercard", "amex", "cup", "jcb", "discover", "diners"]
        setItems(items)
        
        Cache.addListener(for: "paymentMethodConfig") { 
            [weak self] paymentMethodConfig in
            if let config = paymentMethodConfig as? PaymentMethodConfig {
                let supportItems = items.filter({ config.supportCards.contains($0)})
                self?.setItems(supportItems)
            }
        }
    }
    
    private func setItems(_ items: [String]) {
        tg_removeAllSubviews()
        items.forEach { item in
            let icon = CardMap.getIcon(item)
            addSubview(createCardIcon(icon))
        }
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
