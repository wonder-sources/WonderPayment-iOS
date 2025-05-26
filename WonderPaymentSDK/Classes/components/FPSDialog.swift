//
//  FPSView.swift
//  Pods
//
//  Created by X on 2025/5/15.
//

import WebKit
import SVGKit

class FPSDialog : TGRelativeLayout {
    
    lazy var contentView = TGLinearLayout(.vert)
    lazy var scrollView = UIScrollView()
    lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    var onSelected: ((BankApp) -> Void)?

    convenience init() {
        self.init(frame: .zero)
        self.initView()
    }
    
    private func initView() {
        self.tg_height.equal(.fill)
        self.tg_width.equal(.fill)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        contentView.backgroundColor = WonderPayment.uiConfig.secondaryBackground
        contentView.tg_insetsPaddingFromSafeArea = []
        contentView.tg_width.equal(.fill)
        let screenSize = UIScreen.main.bounds
        let minSize = screenSize.height - 44 - safeInsets.top
        contentView.tg_height.equal(.wrap).min(minSize)
        contentView.tg_bottom.equal((-100)%)
        contentView.layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.tg_padding = UIEdgeInsets.only(top: 12)
        addSubview(contentView)
        
        let closeButton = Button()
        let tintColor = WonderPayment.uiConfig.primaryButtonBackground
        closeButton.setImage("close".svg?.withTintColor(tintColor), for: .normal)
        closeButton.tg_right.equal(12)
        closeButton.tg_width.equal(24)
        closeButton.tg_height.equal(24)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        contentView.addSubview(closeButton)
        
        let titleLabel = Label("payWihtFPS".i18n, size: 18, fontStyle: .medium)
        titleLabel.tg_top.equal(8)
        titleLabel.tg_width.equal(.fill)
        titleLabel.tg_left.equal(20)
        titleLabel.tg_right.equal(20)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.tg_top.equal(16)
        scrollView.tg_width.equal(.fill)
        scrollView.tg_height.equal(.fill)
        contentView.addSubview(scrollView)
        
        activityIndicator.tg_centerX.equal(0)
        activityIndicator.tg_centerY.equal(0)
        addSubview(activityIndicator)
        
        getData()
    }
    
    private func getData() {
        activityIndicator.startAnimating()
        PaymentService.getFPSApps().then { json in
            self.activityIndicator.stopAnimating()
            let data = json["pamentApps"].array.map { item in
                let name = item["name"].string
                let img = item["img"].string
                let link = item["redirectLink"].string
                return BankApp(name: name, image: img, link: link)
            }
            self.renderData(data)
        }
    }
    
    private func renderData(_ data: [BankApp]) {
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
        let itemsLayout = TGFlowLayout(.vert,arrangedCount:3)
        itemsLayout.tg_height.equal(.wrap)
        itemsLayout.tg_width.equal(.fill)
        itemsLayout.tg_padding = UIEdgeInsets(top: 16,left: 16,bottom: 16,right: 16)
        itemsLayout.tg_gravity = TGGravity.horz.fill
        itemsLayout.tg_space = 10
        itemsLayout.tg_left.equal(16)
        itemsLayout.tg_right.equal(16)
        itemsLayout.backgroundColor = WonderPayment.uiConfig.background
        itemsLayout.layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        
        for app in data {
            let cell = BankCell()
            cell.configure(with: app)
            cell.tg_height.equal(112)
            cell.onTap = {
                self.onSelected?(app)
            }
            itemsLayout.addSubview(cell)
        }
        scrollView.addSubview(itemsLayout)
    }
    
    @objc func close() {
        Dialog.confirm(title: "closeSession".i18n, message: "sureToLeave".i18n, button1: "continuePayment".i18n, button2: "back".i18n, action2: {
            [unowned self] controller in
            controller.hideWith(animated: true)
            self.dismiss()
        })
    }
    
    
    @objc func dismiss() {
        contentView.tg_bottom.equal((-100)%)
        tg_layoutAnimationWithDuration(0.3)
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            [weak self] in
            self?.removeFromSuperview()
        })
        
    }
    
    func show() {
        let window = keyWindow
        window?.addSubview(self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            [weak self] in
            self?.contentView.tg_bottom.equal(0)
            self?.tg_layoutAnimationWithDuration(0.3)
        })
    }

}

struct BankApp {
    var name: String?
    var image: String?
    var link: String?
    var isSelected: Bool = false
}

class BankCell: TGFrameLayout {

    private let imageView = UIImageView()
    private let titleLabel = Label("", style: .secondary, size: 12)
    private let checkmarkView = UIImageView()
    private let highlightedLayer = TGRelativeLayout(frame: .zero)
    var onTap: (() -> Void)?
    
    convenience init() {
        self.init(frame: .zero)
        self.tg_setTarget(self, action: #selector(touchDown), for: .touchDown)
        self.tg_setTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        let contentLayout = TGLinearLayout(frame: .zero, orientation: .vert)
        contentLayout.tg_padding = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        contentLayout.tg_top.equal(0)
        contentLayout.tg_bottom.equal(0)
        contentLayout.tg_left.equal(0)
        contentLayout.tg_right.equal(0)
        self.addSubview(contentLayout)
        
        let imageContainer = TGRelativeLayout()
        imageContainer.tg_width.equal(.fill)
        imageContainer.tg_height.equal(.wrap)
        contentLayout.addSubview(imageContainer)
        
        imageView.contentMode = .scaleAspectFit
        imageView.tg_width.equal(64)
        imageView.tg_height.equal(64)
        imageView.tg_centerX.equal(0)
        imageView.tg_centerY.equal(0)
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageContainer.addSubview(imageView)
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.tg_width.equal(.fill)
        titleLabel.tg_height.equal(.wrap)
        titleLabel.tg_top.equal(6)
        contentLayout.addSubview(titleLabel)
        
        highlightedLayer.isHidden = true
        highlightedLayer.tg_top.equal(0)
        highlightedLayer.tg_bottom.equal(0)
        highlightedLayer.tg_left.equal(0)
        highlightedLayer.tg_right.equal(0)
        highlightedLayer.layer.cornerRadius = 12
        highlightedLayer.layer.borderWidth = 2
        highlightedLayer.layer.borderColor = UIColor(hexString: "#0094FF").cgColor
        
        if let url = resBundle?.url(forResource: "selected2", withExtension: "svg") {
            let svgImage = SVGKImage.init(contentsOf: url)
            guard let imageView = SvgImageView(svgkImage: svgImage) else {
                return
            }
            imageView.tg_top.equal(0)
            imageView.tg_right.equal(0)
            highlightedLayer.addSubview(imageView)
        }
        self.addSubview(highlightedLayer)
    }
    
    @objc func touchDown() {
        highlightedLayer.isHidden = false
    }
    
    @objc func touchUpInside() {
        highlightedLayer.isHidden = true
        onTap?()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        highlightedLayer.isHidden = true
    }
    

    func configure(with bank: BankApp) {
        titleLabel.text = bank.name?.replace("</br>", with: "\n")
        checkmarkView.isHidden = !bank.isSelected
        imageView.image = UIImage()
        
        let baseUrl = "https://fps.payapps.hkicl.com.hk/"
        guard let img = bank.image, let imgUrl = URL(string: "\(baseUrl)\(img)") else {
            return
        }

        URLSession.shared.dataTask(with: imgUrl) { [weak self] data, response, error in
            guard let self = self, let data = data, let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                // 渐入动画
                self.imageView.alpha = 0
                self.imageView.image = image
                UIView.animate(withDuration: 0.3) {
                    self.imageView.alpha = 1
                }
            }
        }.resume()
    }
}
