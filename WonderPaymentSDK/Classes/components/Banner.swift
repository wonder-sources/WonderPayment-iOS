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
        
        
        var totalItems = data.count
        if totalItems > 1 {
            // 在数据的基础上增加两个虚拟项
            totalItems += 2
        }
        
        for i in 0 ..< totalItems {
            let view: UIView
            let item: AdItem
            
            // 第一张显示最后一个数据，最后一张显示第一个数据
            if i == 0 {
                item = data.last!
            } else if i == totalItems - 1 {
                item = data.first!
            } else {
                item = data[i - 1]
            }
            
            view = createItemView(item)
            
            let x = (width + itemPadding) * CGFloat(i)
            view.frame = CGRect(x: x, y: 0, width: width, height: height)
            scrollView.addSubview(view)
        }
        
        let contentWidth = (width + itemPadding) * CGFloat(totalItems)
        scrollView.contentSize = CGSize(width: contentWidth, height: height)
        scrollView.delegate = self
        placeholderView.isHidden = true
        
        let firstIndex = data.count > 1 ? 1: 0
        let firstOffset = CGPoint(x: (width + itemPadding) * CGFloat(firstIndex), y: 0)
        scrollView.setContentOffset(firstOffset, animated: false)
        
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
                if ImageCache.shared.getImage(forKey: item.displayUrl.md5) != nil {
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
        let image = ImageCache.shared.getImage(forKey: imageUrl.md5)
        return image
    }
    
    func getImageFromNetwork(_ imageUrl: String, completion: @escaping (UIImage?) -> Void) {
        AdService.downloadImage(from: imageUrl) { image in
            if let image = image {
                ImageCache.shared.setImage(image, forKey: imageUrl.md5)
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = width + itemPadding
        let page = Int(scrollView.contentOffset.x / pageWidth)
        
        // 如果滚动到虚拟的最后一页，跳转到真实的第一页
        if page == data.count + 1 {
            scrollView.setContentOffset(CGPoint(x: pageWidth, y: 0), animated: false)
        }
        
        // 如果滚动到虚拟的第一页，跳转到真实的最后一页
        if page == 0 {
            scrollView.setContentOffset(CGPoint(x: pageWidth * CGFloat(data.count), y: 0), animated: false)
        }
    }
    
    @objc private func scrollToNextPage() {
        guard data.count > 1 else { return }
        let pageWidth = width + itemPadding
        let currentPage = Int(scrollView.contentOffset.x / pageWidth)
        var nextPage = currentPage + 1
        
        // 如果到达虚拟的最后一页，自动跳到第一页
        if nextPage == data.count + 1 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            nextPage = 1
        }
        
        scrollTo(page: nextPage)
    }
    
    func scrollTo(page: Int) {
        let x = (width + itemPadding) * CGFloat(page)
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
}
