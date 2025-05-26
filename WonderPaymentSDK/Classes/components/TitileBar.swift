//
//  TitileBar.swift
//  PaymentSDK
//
//  Created by X on 2024/3/2.
//

class TitleBar : TGLinearLayout {
    
    lazy var container = TGLinearLayout(.horz)
    lazy var leftView = Button()
    lazy var titleLabel = UILabel()
    lazy var rightView = Button()
    
    convenience init(){
        self.init(frame: .zero, orientation: .vert)
        self.initView()
    }
    
    private func initView(){
        self.tg_width.equal(.fill)
        self.tg_height.equal(.wrap)
        self.tg_padding = UIEdgeInsets.only(top: safeInsets.top)
        
        container.tg_height.equal(44)
        container.tg_width.equal(.fill)
        self.addSubview(container)
        
        leftView.tg_left.equal(24)
        leftView.tg_height.equal(.fill)
        leftView.tg_width.equal(.wrap)
        container.addSubview(leftView)
        
        titleLabel.textAlignment = .center
        titleLabel.tg_width.equal(.fill)
        titleLabel.tg_height.equal(.wrap)
        titleLabel.tg_centerY.equal(0)
        container.addSubview(titleLabel)
        
        rightView.tg_right.equal(24)
        rightView.tg_height.equal(.fill)
        rightView.tg_width.equal(.wrap)
        container.addSubview(rightView)
    }
}
