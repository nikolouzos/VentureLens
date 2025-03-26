import Foundation

public enum SubscriptionType: String, Decodable {
    case free, premium
}

public struct User {
    public let id: UUID
    public let email: String?
    public let name: String?
    public let subscription: SubscriptionType
    public let unlockedIdeas: [UUID]
    public let lastUnlockTime: Date?
    public let weeklyUnlocksUsed: Int
    public let provider: Provider?

    public init(
        id: UUID,
        email: String?,
        name: String?,
        subscription: SubscriptionType,
        unlockedIdeas: [UUID] = [],
        lastUnlockTime: Date? = nil,
        weeklyUnlocksUsed: Int = 0,
        provider: Provider? = nil
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.subscription = subscription
        self.unlockedIdeas = unlockedIdeas
        self.lastUnlockTime = lastUnlockTime
        self.weeklyUnlocksUsed = weeklyUnlocksUsed
        self.provider = provider
    }
}

#if DEBUG
    public extension User {
        static let mock = User(
            id: UUID(uuidString: "48b3ebc4-039b-42b1-b676-51f5616fe1fb")!,
            email: "test@example.com",
            name: "Test User",
            subscription: .free,
            unlockedIdeas: [],
            lastUnlockTime: Date(timeIntervalSince1970: 0),
            weeklyUnlocksUsed: 0
        )
    }
#endif
