
public struct CreditCardInfo: JSONDecodable, JSONEncodable {
    
    public let id: Int?
    public let number: String?
    public let expMonth: String?
    public let expYear: String?
    public let holderName: String?
    public let issuer: String?
    public let `default`: Bool?
    public let token: String?
    public let holderFirstName: String?
    public let holderLastName: String?
    public let phone: String?
    
    public static func from(json: NSDictionary?) -> CreditCardInfo {
        let id = json?["id"] as? Int
        let number = json?["number"] as? String
        let expMonth = json?["exp_month"] as? String
        let expYear = json?["exp_year"] as? String
        let holderName = json?["holder_name"] as? String
        let issuer = json?["issuer"] as? String
        let `default` = json?["default"] as? Bool
        let token = json?["token"] as? String
        let holderFirstName = json?["holder_first_name"] as? String
        let holderLastName = json?["holder_last_name"] as? String
        let phone = json?["phone"] as? String
        return CreditCardInfo(id: id, number: number, expMonth: expMonth, expYear: expYear, holderName: holderName, issuer: issuer, default: `default`, token: token, holderFirstName: holderFirstName, holderLastName: holderLastName, phone: phone)
    }
    
    public func toJson() -> Dictionary<String, Any?> {
        return [
            "id": id,
            "number": number,
            "exp_month": expMonth,
            "exp_year": expYear,
            "holder_name": holderName,
            "issuer": issuer,
            "default": `default`,
            "token": token,
            "holder_first_name": holderFirstName,
            "holder_last_name": holderLastName,
            "phone": phone,
        ]
    }
}
