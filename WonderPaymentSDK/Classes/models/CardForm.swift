
struct CardForm {
    var number: String = ""
    var expDate: String = ""
    var cvv: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var phone: String = ""
    var save: Bool = true
    
    
    func toArguments() -> [String : Any?] {
        let expDate = expDate
        let arr = expDate.split(separator: "/")
        let expMonth = arr.first
        let expYear = arr.last
        let args: [String : Any?] = [
            "exp_date": expDate.replace("/", with: ""),
            "exp_year": expYear,
            "exp_month": expMonth,
            "number": number,
            "cvv": cvv,
            "holder_name": "\(firstName) \(lastName)",
            "billing_address": [
                "first_name": firstName,
                "last_name": lastName,
                "phone_number": phone,
            ],
        ]
        return args
    }
}
