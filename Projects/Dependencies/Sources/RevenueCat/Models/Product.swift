import Foundation
import RevenueCat

public struct Product: Identifiable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let description: String
    public let price: Decimal
    public let priceString: String
    public let productType: ProductType

    public enum ProductType: Sendable, Equatable {
        case consumable
        case nonConsumable
        case subscription(duration: SubscriptionDuration)

        public enum SubscriptionDuration: String, Sendable {
            case annual = "Annual"
            case monthly = "Monthly"

            init?(from packageType: PackageType) {
                // Only keep the annual & monthly packages
                switch packageType {
                case .annual:
                    self = .annual

                case .monthly:
                    self = .monthly

                default:
                    return nil
                }
            }
        }
    }
}
