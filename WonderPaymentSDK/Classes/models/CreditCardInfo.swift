
struct CreditCardInfo: JSONDecodable {
    
    let number: String?
    let expMonth: String?
    let expYear: String?
    let holderName: String?
    let issuer: String?
    let `default`: Bool?
    let token: String?
    let holderFirstName: String?
    let holderLastName: String?
    //success,pending,failed
    let state: String?
    let verifyUrl: String?
    let verifyUuid: String?
    
    static func from(json: NSDictionary?) -> CreditCardInfo {
        let dynamicJson = DynamicJson(value: json)
        let number = dynamicJson["credit_card"]["number"].string
        let expMonth = dynamicJson["credit_card"]["exp_month"].string
        let expYear = dynamicJson["credit_card"]["exp_year"].string
        let holderName = dynamicJson["credit_card"]["holder_name"].string
        let issuer = dynamicJson["credit_card"]["issuer"].string
        let `default` = dynamicJson["default"].bool
        let token = dynamicJson["token"].string
        let holderFirstName = holderName?.components(separatedBy: " ").first
        let holderLastName = holderName?.components(separatedBy: " ").last
        let state = dynamicJson["state"].string
        let verifyUrl = dynamicJson["verify_url"].string
        let verifyUuid = dynamicJson["verify_uuid"].string
        return CreditCardInfo(number: number, expMonth: expMonth, expYear: expYear, holderName: holderName, issuer: issuer, default: `default`, token: token, holderFirstName: holderFirstName, holderLastName: holderLastName, state: state, verifyUrl: verifyUrl, verifyUuid: verifyUuid)
    }
    
    func toPaymentArguments() -> NSDictionary {
        let expYear = expYear ?? ""
        let expMonth = expMonth ?? ""
        return [
            "issuer": issuer ?? "",
            "exp_date": "\(expYear)\(expMonth)",
            "exp_year": expYear,
            "exp_month": expMonth,
            "number": number ?? "",
            "token": token ?? "",
            "holder_name": holderName ?? "",
            "card_reader_mode": "manual",
            "billing_address": [
                "first_name": holderFirstName ?? "",
                "last_name": holderLastName ?? "",
            ],
        ]
    }
    
}
