//
//  BrowserView.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/4/13.
//

import Foundation
import WebKit
import TangramKit

class BrowserView : TGLinearLayout {
    lazy var titleBar = initTitleBar()
    lazy var webview = initWebView()
    lazy var progressView = UIProgressView()
    var webMessageHandler: ((Any) -> Void)?
    
    init() {
        super.init(frame: .zero, orientation: .vert)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initTitleBar() -> TitleBar{
        let titleBar = TitleBar()
        titleBar.rightView.setImage(
            "close".svg?.qmui_image(withTintColor: WonderPayment.uiConfig.primaryTextColor),
            for: .normal
        )
        
        return titleBar
    }
    
    private func initWebView() -> WKWebView {
        let contentController = WKUserContentController();
        contentController.add(self, name: "native")
        
        let scriptContent = """
        window.flutter_inappwebview = {};
        window.flutter_inappwebview.callHandler = function(name, message) {
            window.webkit.messageHandlers.native.postMessage(message);
        };
        """

        let userScript = WKUserScript(source: scriptContent, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        contentController.addUserScript(userScript)
        let webview = WKWebView(frame: .zero, configuration: config)
        return webview
    }
    
    private func initView() {
        self.backgroundColor = WonderPayment.uiConfig.background
        self.tg_height.equal(.fill)
        self.tg_width.equal(.fill)
        addSubview(titleBar)
        
        let divider = UIView()
        divider.backgroundColor = UIColor(hexString: "#FFE4E4E4")
        divider.tg_width.equal(.fill)
        divider.tg_height.equal(1)
        addSubview(divider)
        
        let frameLayout = TGFrameLayout()
        frameLayout.tg_height.equal(.fill)
        frameLayout.tg_width.equal(.fill)
        addSubview(frameLayout)
        
        webview.tg_height.equal(.fill)
        webview.tg_width.equal(.fill)
        frameLayout.addSubview(webview)
        
        progressView.progress = 0.1
        progressView.trackTintColor = WonderPayment.uiConfig.background
        progressView.progressTintColor = WonderPayment.uiConfig.primaryTextColor
        progressView.tg_width.equal(.fill)
        progressView.tg_height.equal(2)
        progressView.tg_top.equal(0)
        frameLayout.addSubview(progressView)
    }
}

extension BrowserView : WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "native" {
            webMessageHandler?(message.body)
        }
    }
}

class BrowserViewController: UIViewController {
    
    lazy var mView = BrowserView()
    var url : String?
    var finishedCallback: ((Any?) -> Void)?
    
    override func loadView() {
        view = mView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mView.titleBar.rightView.addTarget(self, action: #selector(close), for: .touchUpInside)
        mView.webMessageHandler = handleWebMessage
        
        if let urlString = url, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            mView.webview.load(request)
            mView.webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        }
    }
    
    private func handleWebMessage(_ message: Any) {
        if let message = message as? String {
            let json = DynamicJson.from(message)
            if json["action"].string == "isSuccessful" {
                self.dismiss(animated: true)
                finishedCallback?(json["content"].string == "true")
                finishedCallback = nil
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let progress = mView.webview.estimatedProgress
            mView.progressView.progress = Float(progress)
            mView.progressView.isHidden = progress == 1
        }
    }
    
    @objc func close() {
        self.dismiss(animated: true)
        finishedCallback?(nil)
        finishedCallback = nil
    }
}
