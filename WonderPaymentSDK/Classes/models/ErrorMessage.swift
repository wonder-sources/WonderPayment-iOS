
struct ErrorMessage : Error,Equatable {
    let code: String
    let message: String
    
    static func == (lhs: ErrorMessage, rhs: ErrorMessage) -> Bool{
        return lhs.code == rhs.code && lhs.message == rhs.message
    }
    
    static var networkError: ErrorMessage {
        return ErrorMessage(code: "E100002", message: "networkError".i18n)
    }
    
    static var unknownError: ErrorMessage {
        return ErrorMessage(code: "E100001", message: "unknownError".i18n)
    }
    
    static var dataFormatError: ErrorMessage {
        return ErrorMessage(code: "E100003", message: "dataFormatError".i18n)
    }
    
    static var argumentsError: ErrorMessage {
        return ErrorMessage(code: "E100004", message: "argumentsError".i18n)
    }
    
    static var unsupportedError: ErrorMessage {
        return ErrorMessage(code: "E200001", message: "unsupportedError".i18n)
    }
    
    static var _3dsVerificationError: ErrorMessage {
        return ErrorMessage(code: "E200002", message: "3dsVerificationFailed".i18n)
    }
    
    static var bindCardError: ErrorMessage {
        return ErrorMessage(code: "E200003", message: "bindCardFailed".i18n)
    }
    
}
