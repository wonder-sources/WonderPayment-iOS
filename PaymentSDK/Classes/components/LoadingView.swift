import Lottie

class LoadingView : TGRelativeLayout {
    
    static var loadingView = LoadingView()
    
    var loadingAnimationView: AnimationView!
    
    convenience init() {
        self.init(frame: .zero)
        self.initView()
    }
    
    private func initView() {
        self.tg_width.equal(.fill)
        self.tg_height.equal(.fill)
        self.backgroundColor = WonderPayment.uiConfig.background
        
        let contentLayout = TGLinearLayout(.vert)
        contentLayout.tg_width.equal(.fill)
        contentLayout.tg_height.equal(.wrap)
        contentLayout.tg_centerY.equal(0)
        addSubview(contentLayout)
        
        let path = resBundle?.path(forResource: "w_black_loading", ofType: "json")
        loadingAnimationView = AnimationView(filePath: path!)
        loadingAnimationView.loopMode = .loop
        loadingAnimationView.tg_width.equal(86)
        loadingAnimationView.tg_height.equal(64)
        loadingAnimationView.tg_centerX.equal(0)
        contentLayout.addSubview(loadingAnimationView)
        
        let titleLabel = Label("processing".i18n, size: 24)
        titleLabel.tg_top.equal(24)
        titleLabel.tg_width.equal(.fill)
        titleLabel.tg_height.equal(.wrap)
        titleLabel.textAlignment = .center
        contentLayout.addSubview(titleLabel)
        
        let subTitleLabel = Label("doNotClose".i18n, style: .secondary)
        subTitleLabel.tg_top.equal(8)
        subTitleLabel.tg_width.equal(.fill)
        subTitleLabel.tg_height.equal(.wrap)
        subTitleLabel.textAlignment = .center
        contentLayout.addSubview(subTitleLabel)
        
        let subTitleLabel2 = Label("willAutoRedirect".i18n, style: .secondary)
        subTitleLabel2.tg_top.equal(8)
        subTitleLabel2.tg_width.equal(.fill)
        subTitleLabel2.tg_height.equal(.wrap)
        subTitleLabel2.textAlignment = .center
        contentLayout.addSubview(subTitleLabel2)
    }
    
    static func show() {
        let window = UIApplication.shared.keyWindow
        window?.addSubview(loadingView)
        loadingView.loadingAnimationView.play()
        
//        loadingView.alpha = 0
//        UIView.animate(withDuration: 0.5, animations: {
//            loadingView.alpha = 1
//        }, completion: { _ in
//            loadingView.loadingAnimationView.play()
//        })
    }
    
    static func dismiss() {
        loadingView.loadingAnimationView.stop()
        loadingView.removeFromSuperview()
    }
}
