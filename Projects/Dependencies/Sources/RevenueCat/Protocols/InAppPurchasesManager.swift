import Foundation

public protocol InAppPurchasesManager: Actor {
    /// Current user's customer ID
    var customerID: String? { get }

    /// The URL for opening the user's subscription management screen
    var subscriptionManagementURL: URL? { get }

    /// Check if the user has an active premium subscription
    var isPremiumSubscriptionActive: Bool { get }

    /// Initialize the InAppPurchasesManager with user information
    /// - Parameter userID: Optional user identifier to associate with purchases
    func initialize(userID: String?) async

    /// Fetch available products from the store
    /// - Returns: Array of available products
    func getProducts() async throws(InAppPurchasesError) -> [Product]

    /// Purchase a product
    /// - Parameter productID: The identifier of the product to purchase
    /// - Returns: Purchase result with transaction information
    func purchase(productID: String) async throws(InAppPurchasesError) -> PurchaseResult

    /// Restore previous purchases
    /// - Returns: Boolean indicating if any purchases were restored
    func restorePurchases() async throws(InAppPurchasesError) -> Bool

    /// Get current entitlements for the user
    /// - Returns: Dictionary of active entitlements
    func getCurrentEntitlements() async throws(InAppPurchasesError) -> [EntitlementKey: Entitlement]

    /// Handle subscription status changes
    /// - Parameter handler: Closure to call when subscription status changes
    func observeSubscriptionStatusChanges(handler: @escaping (SubscriptionStatus) -> Void)
}
