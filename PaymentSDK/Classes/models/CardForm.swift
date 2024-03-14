
struct CardForm {
    var number: String = ""
    var expDate: String = ""
    var cvv: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var phone: String = ""
    var save: Bool = true
    
    var isValid: Bool {
        return number.count > 0 &&
        expDate.count > 0 &&
        cvv.count > 0 &&
        firstName.count > 0 &&
        lastName.count > 0 &&
        phone.count > 0
    }
}
