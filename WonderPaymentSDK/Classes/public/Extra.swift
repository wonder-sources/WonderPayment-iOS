
public class Extra : JSONDecodable, JSONEncodable {
    
    var sessionId: String?
    
    public init(sessionId: String? = nil) {
        self.sessionId = sessionId
    }
    
    static func from(json: NSDictionary?) -> Self {
        let sessionId = json?["sessionId"] as? String
        return Extra(sessionId: sessionId) as! Self
    }
    
    func toJson() -> Dictionary<String, Any?> {
        return ["sessionId": sessionId]
    }
    
    public func copy() -> Extra {
        return Extra(sessionId: self.sessionId)
    }
    
}
