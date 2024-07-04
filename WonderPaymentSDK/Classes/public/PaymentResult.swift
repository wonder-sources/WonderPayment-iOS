public enum PaymentResultStatus : String {
    case completed, canceled, failed, pending
}

public class PaymentResult: JSONEncodable {
    public private(set) var status: PaymentResultStatus
    public private(set) var code: String?
    public private(set) var message: String?
    
    public init(status: PaymentResultStatus, code: String? = nil, message: String? = nil) {
        self.status = status
        self.code = code
        self.message = message
    }
    
    public func toJson() -> Dictionary<String, Any?> {
        return [
            "status": status.rawValue,
            "code": code,
            "message": message,
        ]
    }
}
