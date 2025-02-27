import Foundation

public enum SubscriptionType: String, Decodable {
    case free, premium
}

public struct User {
    public let id: UUID
    public let email: String?
    public let name: String?
    public let subscription: SubscriptionType

    public init(
        id: UUID,
        email: String?,
        name: String?,
        subscription: SubscriptionType
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.subscription = subscription
    }
}

#if DEBUG
    extension User {
        public static let mock = User(
            id: UUID(uuidString: "48b3ebc4-039b-42b1-b676-51f5616fe1fb")!,
            email: "test@example.com",
            name: "Test User",
            subscription: .free
        )
    }
#endif
