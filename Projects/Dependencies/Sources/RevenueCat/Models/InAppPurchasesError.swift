import Foundation

public enum InAppPurchasesError: Error {
    case productNotFound
    case purchaseFailed
    case restoreFailed
    case entitlementNotFound
    case noCustomerInfo
    case userCancelled
}
