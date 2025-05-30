import Foundation

public struct PurchaseResult: Sendable {
    public let transactionID: String
    public let productID: String
    public let purchaseDate: Date
    public let isSubscription: Bool
    public let expirationDate: Date?
}
