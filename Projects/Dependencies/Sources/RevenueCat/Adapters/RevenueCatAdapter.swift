import Foundation
import RevenueCat

public actor RevenueCatAdapter: InAppPurchasesManager {
    private let purchases: Purchases
    private var customerInfo: CustomerInfo?

    public var customerID: String? {
        purchases.appUserID
    }

    public var isPremiumSubscriptionActive: Bool {
        customerInfo?.entitlements[EntitlementKey.premium.rawValue]?.isActive ?? false
    }

    public var subscriptionManagementURL: URL? {
        customerInfo?.managementURL
    }

    public init(apiKey: String) {
        Purchases.configure(
            with: Configuration.builder(withAPIKey: apiKey)
                .build()
        )
        purchases = Purchases.shared
    }

    public func initialize(userID: String? = nil) async {
        if let userID {
            do {
                let result = try await purchases.logIn(userID)
                customerInfo = result.customerInfo
            } catch {
                print("Error logging in user to RevenueCat: \(error)")
            }
        } else {
            do {
                customerInfo = try await purchases.customerInfo()
            } catch {
                print("Error fetching customer info: \(error)")
            }
        }
    }

    public func getProducts() async throws(InAppPurchasesError) -> [Product] {
        let offerings = try? await purchases.offerings()

        guard let offering = offerings?.current else {
            throw .productNotFound
        }

        return offering.availablePackages.compactMap { package in
            let storeProduct = package.storeProduct

            let productType: Product.ProductType
            switch storeProduct.productType {
            case .consumable:
                productType = .consumable

            case .nonConsumable:
                productType = .nonConsumable

            case .autoRenewableSubscription, .nonRenewableSubscription:
                guard let subscriptionDuration = Product.ProductType.SubscriptionDuration(
                    from: package.packageType
                ) else {
                    return nil
                }

                productType = .subscription(duration: subscriptionDuration)

            @unknown default:
                productType = .nonConsumable
            }

            return Product(
                id: storeProduct.productIdentifier,
                title: storeProduct.localizedTitle,
                description: storeProduct.localizedDescription,
                price: storeProduct.price as Decimal,
                priceString: storeProduct.localizedPriceString,
                productType: productType
            )
        }
    }

    public func purchase(productID: String) async throws(InAppPurchasesError) -> PurchaseResult {
        let offerings = try? await purchases.offerings()

        guard let offering = offerings?.current,
              let package = offering.availablePackages.first(where: { $0.storeProduct.productIdentifier == productID })
        else {
            throw .productNotFound
        }

        guard let result = try? await purchases.purchase(package: package) else {
            throw .purchaseFailed
        }
        customerInfo = result.customerInfo

        if result.userCancelled {
            throw .userCancelled
        }

        guard let transactionID = result.transaction?.transactionIdentifier else {
            throw .purchaseFailed
        }

        return PurchaseResult(
            transactionID: transactionID,
            productID: productID,
            purchaseDate: Date(),
            isSubscription: package.storeProduct.productType == .autoRenewableSubscription,
            expirationDate: result.customerInfo.entitlements[EntitlementKey.premium.rawValue]?.expirationDate
        )
    }

    public func restorePurchases() async throws(InAppPurchasesError) -> Bool {
        guard let customerInfo = try? await purchases.restorePurchases() else {
            throw .restoreFailed
        }
        self.customerInfo = customerInfo
        return customerInfo.entitlements[EntitlementKey.premium.rawValue]?.isActive ?? false
    }

    public func getCurrentEntitlements() async throws(InAppPurchasesError) -> [EntitlementKey: Entitlement] {
        guard let customerInfo = try? await purchases.customerInfo() else {
            throw .noCustomerInfo
        }
        self.customerInfo = customerInfo

        let entitlements: [EntitlementKey: Entitlement] = Dictionary(
            uniqueKeysWithValues: customerInfo.entitlements.all.compactMap { identifier, entitlement in
                guard let identifier = EntitlementKey(rawValue: identifier) else {
                    return nil
                }

                return (
                    identifier,
                    Entitlement(
                        identifier: identifier,
                        isActive: entitlement.isActive,
                        willRenew: entitlement.willRenew,
                        expirationDate: entitlement.expirationDate,
                        productIdentifier: entitlement.productIdentifier
                    )
                )
            }
        )

        return entitlements
    }

    // MARK: - Delegate Actions

    public func observeSubscriptionStatusChanges(handler: @escaping (SubscriptionStatus) -> Void) {
        purchases.delegate = RevenueCatDelegateHandler(statusChangeHandler: handler)
    }
}

private class RevenueCatDelegateHandler: NSObject, PurchasesDelegate {
    private let statusChangeHandler: (SubscriptionStatus) -> Void

    init(statusChangeHandler: @escaping (SubscriptionStatus) -> Void) {
        self.statusChangeHandler = statusChangeHandler
        super.init()
    }

    func purchases(_: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        let status: SubscriptionStatus

        if let entitlement = customerInfo.entitlements[EntitlementKey.premium.rawValue] {
            if entitlement.isActive {
                if entitlement.expirationDate != nil {
                    let periodType = entitlement.periodType

                    if periodType == .trial {
                        status = .inTrialPeriod
                    } else {
                        status = .active
                    }
                } else {
                    status = .active
                }
            } else {
                status = .expired
            }
        } else {
            status = .notSubscribed
        }

        statusChangeHandler(status)
    }
}
