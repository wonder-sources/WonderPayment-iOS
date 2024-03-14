//
//  TitileBar.swift
//  PaymentSDK
//
//  Created by X on 2024/3/2.
//


class TitleBar : UIView{
    
    lazy var container = UIView()
    lazy var leftView = UIButton()
    lazy var centerView = UIButton()
    lazy var rightView = UIButton()
    
    convenience init(){
        self.init(frame: CGRect.zero)
        self.initView()
    }
    
    private func initView(){
        self.addSubview(container)
        container.addSubview(leftView)
        container.addSubview(centerView)
        container.addSubview(rightView)
        leftView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        rightView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    override func layoutSubviews() {
        self.snp.makeConstraints({ make in
            make.top.left.right.equalToSuperview()
        })
        
        container.snp.remakeConstraints({ make in
            make.bottom.equalToSuperview()
            make.top.left.right.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(44)
        })
        
        leftView.snp.makeConstraints({
            make in
            make.height.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(leftView.snp.height)
            make.left.equalToSuperview().offset(24)
        })
        
        rightView.snp.makeConstraints({
            make in
            make.height.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(rightView.snp.height)
            make.right.equalToSuperview().offset(-24)
        })
        
        centerView.snp.makeConstraints({
            make in
            make.height.centerY.equalToSuperview()
            make.left.equalTo(leftView.snp.right).offset(24)
            make.right.equalTo(rightView.snp.left).offset(-24)
        })
    }
}
