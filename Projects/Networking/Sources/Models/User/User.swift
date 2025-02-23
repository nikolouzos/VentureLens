import Foundation

public struct User {
    public let id: UUID
    public let email: String?
    public let name: String?
    public let subscription: String?

    public init(
        id: UUID,
        email: String?,
        name: String?,
        subscription: String?
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.subscription = subscription
    }
}

#if DEBUG
    extension User {
        static let mock = User(
            id: UUID(uuidString: "48b3ebc4-039b-42b1-b676-51f5616fe1fb")!,
            email: "test@example.com",
            name: "Test User",
            subscription: "Free"
        )
    }
#endif
