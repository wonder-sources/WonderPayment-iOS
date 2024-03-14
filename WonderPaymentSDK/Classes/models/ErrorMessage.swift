
struct ErrorMessage {
    let code: String
    let message: String
    
    static var networkError: ErrorMessage {
        return ErrorMessage(code: "EO100002", message: "networkError".i18n)
    }
    
    static var unknownError: ErrorMessage {
        return ErrorMessage(code: "EO100001", message: "unknownError".i18n)
    }
    
    static var dataFormatError: ErrorMessage {
        return ErrorMessage(code: "EO100003", message: "dataFormatError".i18n)
    }
}
