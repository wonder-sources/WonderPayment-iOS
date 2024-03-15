//
//  CallingCodeView.swift
//  PaymentSDK
//
//  Created by X on 2024/3/6.
//

import Foundation
import TangramKit

class DialingCodeView : TGLinearLayout {
    
    var dialingCode: String = "852"
    lazy var countryItems: [CountryItem] = CountryData.get ?? []
    lazy var iconView = UIImageView()
    lazy var codeLabel = Label("+\(dialingCode)")
    
    convenience init() {
        self.init(frame: .zero, orientation: .horz)
        self.initView()
    }
    
    private func initView() {
        self.tg_hspace = 4
        self.tg_height.equal(50)
        self.tg_width.equal(.wrap)
        self.tg_padding = UIEdgeInsets.only(left: 16)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectDialingCode)))
        
        iconView.tg_width.equal(20)
        iconView.tg_height.equal(20)
        iconView.tg_centerY.equal(0)
        addSubview(iconView)
        
        codeLabel.tg_width.equal(.wrap)
        codeLabel.tg_height.equal(.wrap)
        codeLabel.tg_centerY.equal(0)
        addSubview(codeLabel)
        
        let imageView = UIImageView(image: "arrow_down".svg)
        imageView.tg_width.equal(.wrap)
        imageView.tg_height.equal(.wrap)
        imageView.tg_centerY.equal(0)
        addSubview(imageView)
    }
    
    @objc private func selectDialingCode() {
        let dialog = SelectDialingCodeDialog(data: countryItems, selectedCode: dialingCode)
        dialog.show()
        dialog.selectedCallback = {
            [weak self] code in
            self?.dialingCode = code
            self?.codeLabel.text = "+\(code)"
            self?.setImageBy(code: code)
        }
    }
    
    private func setImageBy(code: String) {
        let item = countryItems.first(where: { $0.callingCode == code})
        let alpha2 = item?.alpha2.lowercased() ?? ""
        iconView.image = "\(alpha2)".svg
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        setImageBy(code: dialingCode)
    }
    
    
}
