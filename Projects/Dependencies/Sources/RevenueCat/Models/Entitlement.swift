import Foundation

public enum EntitlementKey: String, Sendable, CaseIterable {
    case free = "Free"
    case premium = "Premium"
}

public struct Entitlement: Sendable {
    public let identifier: EntitlementKey
    public let isActive: Bool
    public let willRenew: Bool
    public let expirationDate: Date?
    public let productIdentifier: String
}
