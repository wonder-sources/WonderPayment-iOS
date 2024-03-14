
class CardMap {
    static func getIcon(_ key: String) -> String {
        return icons[key] ?? key
    }
    
    static func getName(_ key: String) -> String {
        return names[key] ?? key
    }
    
    static let icons = [
        "visa" : "Visa",
        "mastercard": "MasterCard",
        "cup": "ChinaUnion",
        "jcb": "JCB",
        "discover": "Discover",
        "diners": "DinersClub",
        "amex": "AmericanExpress",
        "unionpay": "UnionPay",
    ]
    
    static let names = [
        "visa" : "VISA",
        "mastercard": "MasterCard",
        "cup": "CUP",
        "jcb": "JCB",
        "discover": "Discover",
        "diners": "Diners Club",
        "amex": "Amex",
        "unionpay": "UnionPay",
    ]
}
