struct CommonResponse: JSONDecodable {
    let code: Int?
    let errorCode: String?
    let message: String?
    let data: Any?
    
    var succeed: Bool { code == 200 }
    
    var error: ErrorMessage {
        ErrorMessage(code: errorCode ?? "", message: message ?? "")
    }
    
    static func from(json: NSDictionary?) -> CommonResponse {
        let code = json?["code"] as? Int
        let errorCode = json?["error_code"] as? String
        let message = json?["message"] as? String
        let data = json?["data"]
        return CommonResponse(code: code, errorCode: errorCode, message: message, data: data)
    }
}
