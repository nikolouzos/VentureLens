import Foundation
@testable import Networking

/// Provides predefined User objects for testing
public enum UserFixtures {
    
    /// Returns a standard test user with all fields populated
    public static func standard() -> User {
        return User(
            id: UUID(uuidString: "48b3ebc4-039b-42b1-b676-51f5616fe1fb")!,
            email: "test@example.com",
            name: "Test User",
            subscription: .free,
            unlockedIdeas: [],
            lastUnlockTime: Date(timeIntervalSince1970: 0),
            weeklyUnlocksUsed: 0,
            provider: .apple
        )
    }
    
    /// Returns a premium user
    public static func premium() -> User {
        return User(
            id: UUID(uuidString: "5a71bd8f-c2e5-4066-b1a3-c04d1c3d3a11")!,
            email: "premium@example.com",
            name: "Premium User",
            subscription: .premium,
            unlockedIdeas: [
                UUID(uuidString: "9d5b35ca-7b4e-47c6-a0c3-7a6748e7a0e7")!,
                UUID(uuidString: "1e9e2f0b-3f4c-4de8-a22c-0e5a7c8a5d12")!
            ],
            lastUnlockTime: Date(timeIntervalSince1970: 1623456789),
            weeklyUnlocksUsed: 1,
            provider: .apple
        )
    }
    
    /// Returns a minimal user with only required fields
    public static func minimal() -> User {
        return User(
            id: UUID(uuidString: "a63b5f8c-1d2e-3f4a-5b6c-7d8e9f0a1b2c")!,
            email: nil,
            name: nil,
            subscription: .free
        )
    }
    
    /// Returns a user with a specific provider
    public static func withProvider(_ provider: Provider) -> User {
        let user = standard()
        
        // Since we can't directly modify fields in the struct, 
        // we need to create a new instance
        return User(
            id: user.id, 
            email: user.email, 
            name: user.name, 
            subscription: user.subscription,
            unlockedIdeas: user.unlockedIdeas,
            lastUnlockTime: user.lastUnlockTime,
            weeklyUnlocksUsed: user.weeklyUnlocksUsed,
            provider: provider
        )
    }
    
    /// Returns a user with configured unlock data
    public static func withUnlocks(count: Int, lastUnlockTime: Date) -> User {
        var unlockedIdeas: [UUID] = []
        for i in 0..<count {
            let idString = String(format: "00000000-0000-0000-0000-%012d", i)
            if let id = UUID(uuidString: idString) {
                unlockedIdeas.append(id)
            }
        }
        
        return User(
            id: UUID(uuidString: "48b3ebc4-039b-42b1-b676-51f5616fe1fb")!,
            email: "test@example.com",
            name: "Test User",
            subscription: .free,
            unlockedIdeas: unlockedIdeas,
            lastUnlockTime: lastUnlockTime,
            weeklyUnlocksUsed: count,
            provider: .apple
        )
    }
}

/// Builder for creating custom User instances for testing
public class UserBuilder {
    private var id: UUID = UUID(uuidString: "48b3ebc4-039b-42b1-b676-51f5616fe1fb")!
    private var email: String? = "test@example.com"
    private var name: String? = "Test User"
    private var subscription: SubscriptionType = .free
    private var unlockedIdeas: [UUID] = []
    private var lastUnlockTime: Date? = nil
    private var weeklyUnlocksUsed: Int = 0
    private var provider: Provider? = nil
    
    /// Creates a new user builder
    public init() {}
    
    /// Sets the user ID
    public func withId(_ id: UUID) -> UserBuilder {
        self.id = id
        return self
    }
    
    /// Sets the user email
    public func withEmail(_ email: String?) -> UserBuilder {
        self.email = email
        return self
    }
    
    /// Sets the user name
    public func withName(_ name: String?) -> UserBuilder {
        self.name = name
        return self
    }
    
    /// Sets the subscription type
    public func withSubscription(_ subscription: SubscriptionType) -> UserBuilder {
        self.subscription = subscription
        return self
    }
    
    /// Sets the unlocked ideas
    public func withUnlockedIdeas(_ unlockedIdeas: [UUID]) -> UserBuilder {
        self.unlockedIdeas = unlockedIdeas
        return self
    }
    
    /// Sets the last unlock time
    public func withLastUnlockTime(_ lastUnlockTime: Date?) -> UserBuilder {
        self.lastUnlockTime = lastUnlockTime
        return self
    }
    
    /// Sets the weekly unlocks used
    public func withWeeklyUnlocksUsed(_ weeklyUnlocksUsed: Int) -> UserBuilder {
        self.weeklyUnlocksUsed = weeklyUnlocksUsed
        return self
    }
    
    /// Sets the provider
    public func withProvider(_ provider: Provider?) -> UserBuilder {
        self.provider = provider
        return self
    }
    
    /// Builds the user with the configured properties
    public func build() -> User {
        return User(
            id: id,
            email: email,
            name: name,
            subscription: subscription,
            unlockedIdeas: unlockedIdeas,
            lastUnlockTime: lastUnlockTime,
            weeklyUnlocksUsed: weeklyUnlocksUsed,
            provider: provider
        )
    }
}

/// Provides predefined UserAttributes objects for testing
public enum UserAttributesFixtures {
    /// Returns standard user attributes with all fields set
    public static func standard() -> UserAttributes {
        return UserAttributes(
            email: "test@example.com",
            name: "Test User"
        )
    }
    
    /// Returns user attributes with only email set
    public static func emailOnly() -> UserAttributes {
        return UserAttributes(
            email: "email.only@example.com",
            name: nil
        )
    }
    
    /// Returns user attributes with only name set
    public static func nameOnly() -> UserAttributes {
        return UserAttributes(
            email: nil,
            name: "Name Only"
        )
    }
    
    /// Returns empty user attributes
    public static func empty() -> UserAttributes {
        return UserAttributes(
            email: nil,
            name: nil
        )
    }
} 
