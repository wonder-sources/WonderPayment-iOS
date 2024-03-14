protocol JSONDecodable {
    static func from(json: NSDictionary?) -> Self
}

extension JSONDecodable {
    static func from(jsonArray: NSArray?) -> Array<Self> {
        var array: [Self] = []
        for item in jsonArray ?? [] {
            if let json = item as? NSDictionary {
                array.append(self.from(json: json))
            }
        }
        return array
    }
}

struct PaymentResponse: JSONDecodable {  // <-- here
    let id: Int?
    let code: Int?
    let errorCode: String?
    let message: String?
    let data: Any?
    
    var succeed: Bool { code == 200 }
    
    var error: ErrorMessage {
        ErrorMessage(code: errorCode ?? "", message: message ?? "")
    }
    
    static func from(json: NSDictionary?) -> PaymentResponse {
        let id = json?["json"] as? Int
        let code = json?["code"] as? Int
        let errorCode = json?["error_code"] as? String
        let message = json?["message"] as? String
        let data = json?["data"]
        return PaymentResponse(id: id, code: code, errorCode: errorCode, message: message, data: data)
    }
}
