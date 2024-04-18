import Lottie
import QMUIKit
import TangramKit

class Loading {
    
    enum LoadingStyle {
        case small, fullScreen
    }
    
    static var loadingController: QMUIModalPresentationViewController?
    
    static func show(style: LoadingStyle = .small) {
        dismiss()
        let loadingView : UIView
        if style == .small {
            loadingView = SmallLoadingView()
        } else {
            loadingView = FullScreenLoadingView()
        }
        loadingController = QMUIModalPresentationViewController()
        loadingController?.contentViewMargins = UIEdgeInsets.zero
        loadingController?.contentView = loadingView
        loadingController?.isModal = true
        loadingController?.showWith(animated: true)
    }
    
    static func dismiss(completion: ((Bool) -> Void)? = nil) {
        loadingController?.hideWith(animated: true) { completed in
            loadingController = nil
            completion?(completed)
        }
    }
}

class FullScreenLoadingView : TGRelativeLayout {
        
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
        loadingAnimationView.backgroundBehavior = .pauseAndRestore
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
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil {
            loadingAnimationView.play()
        }
    }
    
    deinit {
        loadingAnimationView.stop()
    }
}


class SmallLoadingView : UIView {
        
    var loadingAnimationView: AnimationView!
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.backgroundColor = WonderPayment.uiConfig.background
        self.layer.cornerRadius = 16
        
        let path = resBundle?.path(forResource: "w_black_loading", ofType: "json")
        loadingAnimationView = AnimationView(filePath: path!)
        loadingAnimationView.backgroundBehavior = .pauseAndRestore
        loadingAnimationView.loopMode = .loop
        loadingAnimationView.frame.size = CGSize(width: 50, height: 36)
        loadingAnimationView.center = self.center
        self.addSubview(loadingAnimationView)
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil {
            loadingAnimationView.play()
        }
    }
    
    deinit {
        loadingAnimationView.stop()
    }
}
