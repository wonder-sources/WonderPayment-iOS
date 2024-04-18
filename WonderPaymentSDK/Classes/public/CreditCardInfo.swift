
public struct CreditCardInfo: JSONDecodable {
    
    public let number: String?
    public let expMonth: String?
    public let expYear: String?
    public let holderName: String?
    public let issuer: String?
    public let `default`: Bool?
    public let token: String?
    public let holderFirstName: String?
    public let holderLastName: String?
    //success,pending,failed
    public let state: String?
    public let verifyUrl: String?
    public let verifyUuid: String?
    
    public static func from(json: NSDictionary?) -> CreditCardInfo {
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
    
}
