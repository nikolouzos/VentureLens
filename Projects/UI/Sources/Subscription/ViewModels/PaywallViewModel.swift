import Combine
import Core
import Dependencies
import Foundation
import SwiftUI

@MainActor
public class PaywallViewModel: ObservableObject {
    typealias SubscriptionPlan = Product.ProductType.SubscriptionDuration

    struct FeatureComparison: Identifiable {
        public let id = UUID()
        public let feature: String
        public let freeAccess: String
        public let premiumAccess: String
    }

    private let urlOpener: URLOpener
    let dependencies: Dependencies

    let featureComparison: [FeatureComparison] = [
        FeatureComparison(feature: "Idea Generation", freeAccess: "✓ Weekly Idea", premiumAccess: "✓ Daily Ideas"),
        FeatureComparison(feature: "Financial Data", freeAccess: "✓ Basic Data", premiumAccess: "✓ Full Financials"),
        FeatureComparison(feature: "Growth Metrics", freeAccess: "✓ Limited Access", premiumAccess: "✓ CAC, LTV Data"),
        FeatureComparison(feature: "Market Analysis", freeAccess: "-", premiumAccess: "✓ Market/Tech"),
        FeatureComparison(feature: "Risk Assessment", freeAccess: "-", premiumAccess: "✓ Ethics/Risk"),
        FeatureComparison(feature: "Planning", freeAccess: "-", premiumAccess: "✓ Detailed Product Roadmaps"),
        FeatureComparison(feature: "Support", freeAccess: "-", premiumAccess: "✓ Priority Support"),
    ]

    // MARK: - Published Properties

    @Published private(set) var products: [Product] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var isPurchasing: Bool = false
    @Published private(set) var isRestoring: Bool = false
    @Published private(set) var purchaseSuccess: Bool = false
    @Published private(set) var isPremiumActive: Bool = false
    @Published private(set) var renewalDate: Date?
    @Published var showPaywallView = false
    @Published var showManagementView = false

    // Add selectedPlan property
    @Published var selectedPlan: SubscriptionPlan = .annual

    // MARK: - Computed Properties

    // Add computed properties for products and savings
    public var monthlyProduct: Product? {
        products.first { $0.productType == .subscription(duration: .monthly) }
    }

    public var annualProduct: Product? {
        products.first { $0.productType == .subscription(duration: .annual) }
    }

    public var selectedProduct: Product? {
        switch selectedPlan {
        case .monthly:
            monthlyProduct

        case .annual:
            annualProduct
        }
    }

    public var savingsPercentage: Int? {
        guard let annualPrice = annualProduct?.price,
              let monthlyPrice = monthlyProduct?.price,
              monthlyPrice > 0
        else {
            return nil
        }
        let totalMonthlyCost = monthlyPrice * 12
        guard totalMonthlyCost > annualPrice else { return nil }

        let savings = totalMonthlyCost - annualPrice
        let percentage = NSDecimalNumber(decimal: savings / totalMonthlyCost).doubleValue
        return Int(percentage * 100)
    }

    private var inAppPurchasesManager: InAppPurchasesManager {
        dependencies.inAppPurchasesManager
    }

    // MARK: - Initialization

    public init(
        dependencies: Dependencies,
        urlOpener: URLOpener? = nil
    ) {
        self.dependencies = dependencies
        self.urlOpener = urlOpener ?? UIApplication.shared
    }

    // MARK: - Public Methods

    public func loadProducts() async {
        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            let loadedProducts = try await inAppPurchasesManager.getProducts()
            products = loadedProducts.sorted { $0.price < $1.price }
        } catch {
            handleError(error)
        }
    }

    public func purchase(productID: String) async {
        isPurchasing = true
        errorMessage = nil
        purchaseSuccess = false

        defer { isPurchasing = false }

        do {
            _ = try await inAppPurchasesManager.purchase(productID: productID)
            purchaseSuccess = true
            await loadSubscriptionDetails()
        } catch {
            handleError(error)
        }
    }

    public func restorePurchases() async {
        isRestoring = true
        errorMessage = nil

        defer { isRestoring = false }

        do {
            let restored = try await inAppPurchasesManager.restorePurchases()
            purchaseSuccess = restored
            if restored {
                await loadSubscriptionDetails()
            }
        } catch {
            handleError(error)
        }
    }

    public func loadSubscriptionDetails() async {
        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            let entitlements = try await inAppPurchasesManager.getCurrentEntitlements()

            if let premiumEntitlement = entitlements[.premium], premiumEntitlement.isActive {
                isPremiumActive = true
                renewalDate = premiumEntitlement.expirationDate
            } else {
                isPremiumActive = false
                renewalDate = nil
            }
        } catch {
            handleError(error)
            isPremiumActive = false
            renewalDate = nil
        }
    }

    public func openSubscriptionManagement() {
        Task { @MainActor in
            guard let subscriptionManagementURL = await inAppPurchasesManager.subscriptionManagementURL,
                  urlOpener.canOpenURL(subscriptionManagementURL)
            else {
                return
            }

            await urlOpener.open(subscriptionManagementURL, options: [:])
        }
    }

    public func showPaywall() {
        showPaywallView = true
    }

    public func showManagement() {
        showManagementView = true
    }

    public func dismissPurchaseSuccess() {
        purchaseSuccess = false
    }

    private func handleError(_ error: InAppPurchasesError) {
        switch error {
        case .productNotFound:
            errorMessage = "Could not retrieve product information. Please try again."

        case .purchaseFailed:
            errorMessage = "Your purchase failed. Please check your payment method and try again."

        case .restoreFailed:
            errorMessage = "Restoring purchases failed. Please check your subscription status and try again."

        case .entitlementNotFound:
            errorMessage = "Could not verify subscription status. Please try again."

        case .noCustomerInfo:
            errorMessage = "No customer information available. Please try again."

        case .userCancelled:
            errorMessage = nil
        }
    }
}
