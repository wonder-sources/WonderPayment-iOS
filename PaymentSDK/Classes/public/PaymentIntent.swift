public class PaymentIntent {
    public var amount: Double
    public var currency: String
    public var orderNumber: String
    public var paymentMethod: PaymentMethod?
    public var transactionType: TransactionType = .sale
    
    public init(amount: Double, currency: String, orderNumber: String, paymentMethod: PaymentMethod? = nil, transactionType: TransactionType = .sale) {
        self.amount = amount
        self.currency = currency
        self.orderNumber = orderNumber
        self.paymentMethod = paymentMethod
        self.transactionType = transactionType
    }
    
    func copy() -> PaymentIntent {
        return PaymentIntent(
            amount: self.amount,
            currency: self.currency,
            orderNumber: self.orderNumber,
            paymentMethod: self.paymentMethod,
            transactionType: self.transactionType
        )
    }
}
