import TangramKit

class Banner: TGFrameLayout {
    
    lazy var placeholderView = PlaceholderView()
    lazy var scrollView = UIScrollView()
    lazy var screenWidth = UIScreen.main.bounds.width
    lazy var width = screenWidth - 48
    lazy var height = width / 328 * 120
    let itemPadding: CGFloat = 20
    var data: Array<AdItem> = []
    var currentPage = 1
    var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initView() {
        self.tg_width.equal(.fill)
        self.tg_height.equal(height)
        self.layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        self.clipsToBounds = true
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.tg_width.equal(width + itemPadding)
        scrollView.tg_height.equal(.fill)
        addSubview(scrollView)
        
        addSubview(placeholderView)
    }
    
    func setData(_ data: Array<AdItem>) {
        self.data = data
        prepareResources(data) {
            [weak self] readyData in
            let succeedCount = readyData.filter({$0.value}).count
            if succeedCount == data.count {
                self?.refresh(data)
            }
        }
    }
    
    func refresh(_ data: Array<AdItem>) {
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        for i in 0 ..< data.count {
            let view = createItemView(data[i])
            let x = (width + itemPadding) * CGFloat(i)
            view.frame = CGRect(x: x, y: 0, width: width, height: height)
            scrollView.addSubview(view)
        }
        
        let contentWidth = (width + itemPadding) * CGFloat(data.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: height)
        scrollView.delegate = self
        placeholderView.isHidden = true
        
        if data.count > 1 {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: {
            [weak self] timer in
            self?.scrollToNextPage()
        })
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func createItemView(_ item: AdItem) -> UIView {
        let view: UIView
        if item.displayType == .image {
            let imageView = UIImageView()
            imageView.layer.cornerRadius = WonderPayment.uiConfig.borderRadius
            imageView.clipsToBounds = true
            imageView.image = getImageFromCache(item.displayUrl)
            view = imageView
        } else if item.displayType == .url {
            view = UIView()
        } else {
            view = UIView()
        }
        
        if (item.targetLink?.isNotEmpty ?? false) {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openInBrowser(sender:)))
            gestureRecognizer.name = item.targetLink
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(gestureRecognizer)
        }
        return view
    }
    
    @objc func openInBrowser(sender: UITapGestureRecognizer) {
        let browserController = BrowserViewController()
        browserController.url = sender.name
        browserController.modalPresentationStyle = .fullScreen
        UIViewController.current()?.present(browserController, animated: true)
    }
    
    func prepareResources(_ data: Array<AdItem>, completion: @escaping (Dictionary<String, Bool>) -> Void) {
        var dictionary: Dictionary<String, Bool> = [:] {
            didSet {
                if dictionary.count == data.count {
                    completion(dictionary)
                }
            }
        }
        
        for item in data {
            let key = item.displayUrl.md5
            if item.displayType == .image {
                if DiskCache.shared.getImage(forKey: item.displayUrl.md5) != nil {
                    dictionary[key] = true
                } else {
                    getImageFromNetwork(item.displayUrl) { image in
                        dictionary[key] = image != nil
                    }
                }
            } else {
                dictionary[key] = true
            }
        }
    }
    
    func getImageFromCache(_ imageUrl: String) -> UIImage? {
        let image = DiskCache.shared.getImage(forKey: imageUrl.md5)
        return image
    }
    
    func getImageFromNetwork(_ imageUrl: String, completion: @escaping (UIImage?) -> Void) {
        AdService.downloadImage(from: imageUrl) { image in
            if let image = image {
                DiskCache.shared.setImage(image, forKey: imageUrl.md5)
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    
    class PlaceholderView : TGFrameLayout {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            initView()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        
        private func initView() {
            self.tg_width.equal(.fill)
            self.tg_height.equal(.fill)
            
            let imageView = SvgImageView(named: "ad_bg")
            imageView.tg_width.equal(.fill)
            imageView.tg_height.equal(.fill)
            addSubview(imageView)
            
            let centerLayout = TGLinearLayout(.vert)
            centerLayout.tg_width.equal(.fill)
            centerLayout.tg_height.equal(.wrap)
            centerLayout.tg_centerY.equal(0)
            centerLayout.tg_left.equal(20)
            centerLayout.tg_right.equal(20)
            addSubview(centerLayout)
            
            let label1 = UILabel()
            label1.text = "streetHailPay".i18n
            label1.font = UIFont(name: "Helvetica-Bold", size: 14)
            label1.textColor = UIColor(hexString: "#FF523535")
            label1.tg_width.equal(.fill)
            label1.tg_height.equal(.wrap)
            centerLayout.addSubview(label1)
            
            let label2 = UILabel()
            let text = "serviceFee".i18n
            let range = (text as NSString).range(of: "$0")
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor(hexString: "#FF523535"), range: NSRange(location: 0, length: text.count))
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
            label2.attributedText = attributedString
            label2.font = UIFont(name: "Helvetica-Bold", size: 24)
            label2.tg_top.equal(4)
            label2.tg_width.equal(.fill)
            label2.tg_height.equal(.wrap)
            centerLayout.addSubview(label2)
        }
    }
}

extension Banner: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    @objc private func scrollToNextPage() {
        let pageWidth = width + itemPadding
        let page = Int(scrollView.contentOffset.x / pageWidth) + 1
        
        let nextPage: Int
        if page == data.count {
            nextPage = 1
        } else {
            nextPage = page + 1
        }
        scrollTo(page: nextPage)
    }
    
    func scrollTo(page: Int) {
        let x = (width + itemPadding) * CGFloat(page - 1)
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
}
