import QMUIKit
import TangramKit

class UI {
    static func call(_ call: @escaping () -> Void ) {
        DispatchQueue.main.async {
            call()
        }
    }
}

var safeInsets: UIEdgeInsets {
    if let window = UIApplication.shared.windows.first {
        return window.safeAreaInsets
    }
    return .zero
}

var resBundle: Bundle? {
    let bundle = Bundle(for: PaymentsViewController.self)
    if let resUrl = bundle.url(forResource: "WonderPaymentSDK_Resources", withExtension: "bundle"),
       let resBundle = Bundle(url: resUrl) {
        return resBundle
    }
    return nil
}

func formatAmount(_ amount: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2

    return formatter.string(from: NSNumber(value: amount)) ?? "0.00"
}

func formatCardNumber(issuer: String, number: String) -> String {
    let name = CardMap.getName(issuer)
    var formatted = "\(name) **"
    if number.count > 4 {
        formatted = "\(formatted)\(number.suffix(4))"
    }
    return formatted
}

func prettyPrint(jsonData: Data) {
    print("----------------------------")
    if let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
        prettyPrint(arrayOrMap: json)
    }
}

func prettyPrint(arrayOrMap: Any) {
    print("----------------------------")
    if  let jsonData = try? JSONSerialization.data(withJSONObject: arrayOrMap, options: .prettyPrinted) {
        print(String(decoding: jsonData, as: UTF8.self))
    }
}

func alert(_ message: String) {
    let dialogController = QMUIDialogViewController()
    dialogController.title = "Debug"
    let contentView = TGLinearLayout(.vert)
    contentView.tg_width.equal(.fill)
    contentView.tg_height.equal(.wrap)
    contentView.tg_padding = UIEdgeInsets.all(16)
    let msgLabel = UILabel()
    msgLabel.text = message
    msgLabel.tg_width.equal(.fill)
    msgLabel.tg_height.equal(.wrap)
    contentView.addSubview(msgLabel)
    dialogController.contentView = contentView
    dialogController.addCancelButton(withText: "Cancel")
    dialogController.show()
}

func getMethodNameAndIcon(_ method: PaymentMethod) -> (String, String?) {
    switch method.type {
    case .alipay:
        return ("alipay".i18n, "Alipay")
    case .alipayHK:
        return ("alipayHK".i18n, "AlipayHK")
    case .applePay:
        return ("Apple Pay", "ApplePay2")
    case .creditCard:
        let issuer = method.arguments?["issuer"] as? String
        let name = CardMap.getName(issuer ?? "")
        let icon = CardMap.getIcon(issuer ?? "")
        return (name, icon)
    case .fps:
        return ("FPS", "FPS")
    case .octopus:
        return ("octopus".i18n, "Octopus")
    case .unionPay:
        return ("unionPay".i18n, "UnionPay")
    case .wechat:
        return  ("wechatPay".i18n, "WechatPay")
    }
}
