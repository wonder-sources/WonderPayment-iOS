//
//  Button.swift
//  PaymentSDK
//
//  Created by X on 2024/3/8.
//

import Foundation

class Button : HighlightButton {
    
    enum ButtonStyle {
        case secondary, primary, warning
    }
    
    var style: ButtonStyle = .secondary
    
    /// 图片和文字之间的间距
    var imageSpacing: CGFloat = 0 {
        didSet {
            updateEdgeInsets()
        }
    }

    
    convenience init(title: String, image: UIImage? = nil, imageSpacing: CGFloat = 8, style: ButtonStyle = .secondary) {
        self.init(frame: .zero)
        self.style = style
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
        self.imageSpacing = imageSpacing
        initView()
    }
    
    private func initView() {
        let backgroundColor: UIColor
        let titleColor: UIColor
        
        switch(style) {
        case.secondary:
            backgroundColor = WonderPayment.uiConfig.secondaryButtonBackground
            titleColor = WonderPayment.uiConfig.secondaryButtonColor
            layer.borderWidth = 1
        case .primary:
            backgroundColor = WonderPayment.uiConfig.primaryButtonBackground
            titleColor = WonderPayment.uiConfig.primaryButtonColor
        case .warning:
            backgroundColor = WonderPayment.uiConfig.secondaryButtonBackground
            titleColor = WonderPayment.uiConfig.errorColor
        }
        
        self.backgroundColor = backgroundColor
        setTitleColor(titleColor, for: .normal)
        layer.cornerRadius = min(WonderPayment.uiConfig.borderRadius, 26)
        titleLabel?.font = UIFont(name: "Outfit-Medium", size: 16)
        if style == .warning {
            self.layer.borderWidth = 1
            self.layer.borderColor = titleColor.cgColor
        }
        tg_height.equal(52)
        tg_width.equal(.fill)
    }
    
    
    // 更新图片和标题之间的间距
    private func updateEdgeInsets() {
        guard let imageView = self.imageView, let titleLabel = self.titleLabel else {
            return
        }
        
        let spacing = imageSpacing
        
        // 根据图片和标题的大小来计算并调整imageEdgeInsets和titleEdgeInsets
        self.imageEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -spacing / 2,
            bottom: 0,
            right: spacing / 2
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: spacing / 2,
            bottom: 0,
            right: -spacing / 2
        )
        
        self.contentEdgeInsets = UIEdgeInsets(
            top: 0,
            left: spacing / 2,
            bottom: 0,
            right: spacing / 2
        )
    }
    
    // 监听布局变化，动态刷新间距
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageSpacing != 0 {
            updateEdgeInsets()
        }
    }
}


class HighlightButton: UIButton {
    
    // MARK: - Public Properties
    var highlightedBackgroundColor: UIColor? {
        didSet {
            if highlightedBackgroundColor != nil {
                adjustsButtonWhenHighlighted = false
            }
        }
    }
    
    var highlightedBorderColor: UIColor? {
        didSet {
            if highlightedBorderColor != nil {
                adjustsButtonWhenHighlighted = false
            }
        }
    }
    
    var adjustsButtonWhenHighlighted: Bool = true
    var adjustsButtonWhenDisabled: Bool = true
    
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            highlightedBackgroundLayer?.cornerRadius = cornerRadius
        }
    }
    
    // MARK: - Private Properties
    private var originalBorderColor: UIColor?
    private var highlightedBackgroundLayer: CALayer?
    
    private let normalAlpha: CGFloat = 1.0
    private let highlightedAlpha: CGFloat = 0.5
    private let disabledAlpha: CGFloat = 0.5

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        adjustsImageWhenHighlighted = false
        adjustsImageWhenDisabled = false
    }
    
    // MARK: - Highlight Handling
    override var isHighlighted: Bool {
        didSet {
            handleHighlightStateChange()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if adjustsButtonWhenDisabled {
                alpha = isEnabled ? normalAlpha : disabledAlpha
            }
        }
    }
    
    private func handleHighlightStateChange() {
        if isHighlighted {
            if originalBorderColor == nil, let borderColor = layer.borderColor {
                originalBorderColor = UIColor(cgColor: borderColor)
            }
        }
        
        if let highlightedBackgroundColor = highlightedBackgroundColor {
            applyHighlightedBackground(highlightedBackgroundColor)
        }
        
        if let highlightedBorderColor = highlightedBorderColor {
            applyHighlightedBorder(highlightedBorderColor)
        }
        
        if adjustsButtonWhenHighlighted {
            alpha = isHighlighted ? highlightedAlpha : normalAlpha
        }
        
        if !isHighlighted {
            restoreBorderColorIfNeeded()
            removeHighlightedBackgroundLayer()
        }
    }
    
    private func applyHighlightedBackground(_ color: UIColor) {
        if highlightedBackgroundLayer == nil {
            let layer = CALayer()
            layer.masksToBounds = true
            self.layer.insertSublayer(layer, at: 0)
            highlightedBackgroundLayer = layer
        }
        highlightedBackgroundLayer?.backgroundColor = color.cgColor
        highlightedBackgroundLayer?.frame = bounds
        highlightedBackgroundLayer?.cornerRadius = layer.cornerRadius
    }
    
    private func applyHighlightedBorder(_ color: UIColor) {
        layer.borderColor = color.cgColor
    }
    
    private func restoreBorderColorIfNeeded() {
        if let originalColor = originalBorderColor {
            layer.borderColor = originalColor.cgColor
            originalBorderColor = nil
        }
    }
    
    private func removeHighlightedBackgroundLayer() {
        highlightedBackgroundLayer?.removeFromSuperlayer()
        highlightedBackgroundLayer = nil
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        highlightedBackgroundLayer?.frame = bounds
    }
}
