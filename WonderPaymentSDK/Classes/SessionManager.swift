
class SessionManager {
    
    class SessionData {
        var sessionId: String
        var orderNumber: String
        var transactions: [String]
        
        init(
            sessionId: String,
            orderNumber: String,
            transactions: [String]
        ) {
            self.sessionId = sessionId
            self.orderNumber = orderNumber
            self.transactions = transactions
        }
        
        func toJsonString() -> String {
            let dict: [String: Any] = [
                "sessionId": sessionId,
                "orderNumber": orderNumber,
                "transactions": transactions
            ]
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                return jsonString ?? ""
            } catch {
                print("Error converting dictionary to JSON: \(error)")
                return ""
            }
        }
        
        static func from(jsonString: String) -> SessionData {
            let json = DynamicJson.from(jsonString)
            let sessionId = json["sessionId"].string ?? ""
            let orderNumber = json["orderNumber"].string ?? ""
            let transactions = json["transactions"].array.compactMap({$0.string})
            return SessionData(sessionId: sessionId, orderNumber: orderNumber, transactions: transactions)
        }
    }
    
    
    static let shared = SessionManager()
    let sessionKey = "WonderPaymentSDK.session"
    var sessionData: SessionData?
    
    
    private init() {
        if let jsonString = UserDefaults.standard.string(forKey: sessionKey) {
            sessionData = SessionData.from(jsonString: jsonString)
        }
    }
    
    func createSession(_ sessionId: String?, orderNumber: String, transactionId: String) {
        let sid = sessionId ?? orderNumber
        if sessionData?.sessionId == sid {
            if sessionData?.orderNumber == orderNumber {
                sessionData?.transactions.append(transactionId)
            } else {
                sessionData?.orderNumber = orderNumber
                sessionData?.transactions = [transactionId]
            }
        } else {
            sessionData = SessionData(sessionId: sid, orderNumber: orderNumber, transactions: [transactionId])
        }
        let jsonString = sessionData?.toJsonString()
//        print(jsonString)
        UserDefaults.standard.setValue(jsonString, forKey: sessionKey)
    }
    
    func getSessionData(_ sessionId: String) -> SessionData? {
        if sessionId == sessionData?.sessionId {
            return sessionData
        }
        return nil
    }
}
