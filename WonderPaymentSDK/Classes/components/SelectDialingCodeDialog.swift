//
//  SelectDialingCodeDialog.swift
//  PaymentSDK
//
//  Created by X on 2024/3/6.
//

import Foundation
import QMUIKit
import TangramKit

class SelectDialingCodeDialog : TGRelativeLayout {
    
    lazy var contentView = TGLinearLayout(.vert)
    lazy var tableView = UITableView()
    var originalData: [CountryItem] = []
    var data: [CountryItem] = []
    var selectedCode: String = "852"
    var lastSelected: IndexPath?
    var selectedCallback: ((String) -> Void)?
    
    convenience init(data: [CountryItem], selectedCode: String, selectedCallback: ((String) -> Void)? = nil) {
        self.init(frame: .zero)
        self.originalData = data
        self.data = data
        self.selectedCode = selectedCode
        self.selectedCallback = selectedCallback
        self.initView()
    }
    
    private func initView() {
        self.tg_height.equal(.fill)
        self.tg_width.equal(.fill)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top ?? 20
        let windowHeight = window?.frame.height ?? 0
        let contentViewHeight = windowHeight - topPadding
        contentView.tg_height.equal(contentViewHeight)
        contentView.tg_width.equal(.fill)
        contentView.tg_bottom.equal((-100)%)
        contentView.backgroundColor = WonderPayment.uiConfig.background
        contentView.layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.tg_padding = UIEdgeInsets.only(top: 8, left: 16, right: 20)
        addSubview(contentView)
        
        let closeButton = QMUIButton()
        closeButton.setImage("close".svg, for: .normal)
        closeButton.tg_right.equal(0)
        closeButton.tg_width.equal(24)
        closeButton.tg_height.equal(24)
        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        contentView.addSubview(closeButton)
        
        let titleLabel = Label("dialingCode".i18n, size: 24)
        titleLabel.tg_width.equal(.fill)
        titleLabel.tg_height.equal(.wrap)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        let leftView = TGLinearLayout(.horz)
        leftView.tg_width.equal(.wrap)
        leftView.tg_height.equal(42)
        leftView.tg_padding = UIEdgeInsets.only(left: 8)
        let iconView = UIImageView(image: "search".svg)
        iconView.tg_width.equal(24)
        iconView.tg_height.equal(22)
        iconView.tg_centerY.equal(0)
        leftView.addSubview(iconView)
        
        let searchTextField = TextFieldView(placeholder: "search".i18n, leftView: leftView)
        searchTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        searchTextField.returnKeyType = .done
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.delegate = self
        
        searchTextField.tg_top.equal(6)
        searchTextField.tg_height.equal(42)
        searchTextField.tg_width.equal(.fill)
        searchTextField.layer.cornerRadius = WonderPayment.uiConfig.borderRadius
        searchTextField.textInsets = UIEdgeInsets.only(left: 2, right: 16)
        contentView.addSubview(searchTextField)
        
        
        tableView.tg_top.equal(22)
        tableView.tg_height.equal(.fill)
        tableView.tg_left.equal(-16)
        tableView.tg_right.equal(-20)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DialingCodeCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = true
        tableView.backgroundColor = WonderPayment.uiConfig.background
        contentView.addSubview(tableView)
    }
    
    
    @objc func textDidChange(_ sender: UITextField) {
        let searchText = sender.text?.lowercased() ?? ""
        if searchText.isEmpty {
            data = originalData
            tableView.reloadData()
            return
        }
        let results = originalData.filter { item in
            return item.callingCode.contains(searchText) || item.countryName.lowercased().contains(searchText)
        }
        data = results
        tableView.reloadData()
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
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            [weak self] in
            self?.contentView.tg_bottom.equal(0)
            self?.tg_layoutAnimationWithDuration(0.3)
        })
    }
}


extension SelectDialingCodeDialog: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DialingCodeCell
        let item = data[indexPath.row]
        let alpha2 = item.alpha2.lowercased()
        cell.mImageView.image = "\(alpha2)".svg
        cell.nameLabel.text = item.countryName
        cell.codeLabel.text = "+\(item.callingCode)"
        cell.isSelected = item.callingCode == selectedCode
        cell.selectedIcon.isHidden = !cell.isSelected
        if cell.isSelected {
            lastSelected = indexPath
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        selectedCode = item.callingCode
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        var rows = [indexPath]
        if lastSelected != nil {
            rows.append(lastSelected!)
        }
        tableView.reloadRows(at: rows, with: .automatic)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            [weak self] in
            self?.selectedCallback?(self!.selectedCode)
            self?.endEditing(true)
            self?.dismiss()
        })
    }
    
}

extension SelectDialingCodeDialog : QMUITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(false)
        return false
    }
}

class DialingCodeCell : UITableViewCell {
    
    lazy var mImageView = UIImageView()
    lazy var nameLabel = Label("")
    lazy var codeLabel = Label("")
    lazy var selectedIcon = UIImageView(image: "checked2".svg)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black.withAlphaComponent(0.1)
        self.selectedBackgroundView = backgroundView
        self.backgroundColor = WonderPayment.uiConfig.background
        let contentLayout = TGLinearLayout(.horz)
        contentLayout.tg_height.equal(.fill)
        contentLayout.tg_width.equal(.fill)
        contentLayout.tg_padding = UIEdgeInsets.only(left:24, right: 24)
        
        mImageView.tg_centerY.equal(0)
        mImageView.tg_height.equal(32)
        mImageView.tg_width.equal(32)
        contentLayout.addSubview(mImageView)
        
        let textLayout = TGLinearLayout(.vert)
        textLayout.tg_height.equal(.wrap)
        textLayout.tg_width.equal(.fill)
        textLayout.tg_vspace = 4
        textLayout.tg_left.equal(14)
        textLayout.tg_centerY.equal(0)
        contentLayout.addSubview(textLayout)
        
        nameLabel.tg_width.equal(.fill)
        nameLabel.tg_height.equal(.wrap)
        textLayout.addSubview(nameLabel)
        
        codeLabel.tg_width.equal(.fill)
        codeLabel.tg_height.equal(.wrap)
        textLayout.addSubview(codeLabel)
        
        selectedIcon.tg_width.equal(.wrap)
        selectedIcon.tg_height.equal(.wrap)
        selectedIcon.tg_centerY.equal(0)
        contentLayout.addSubview(selectedIcon)
        
        contentView.addSubview(contentLayout)
    }
}
