import XCTest
@testable import Networking
import NetworkingTestHelpers

final class UserModelTests: XCTestCase {
    func testUserInitialization() {
        // Given
        let id = UUID()
        let email = "user@example.com"
        let name = "Test User"
        let subscription = SubscriptionType.free
        
        // When
        let user = User(
            id: id,
            email: email,
            name: name,
            subscription: subscription
        )
        
        // Then
        XCTAssertEqual(user.id, id)
        XCTAssertEqual(user.email, email)
        XCTAssertEqual(user.name, name)
        XCTAssertEqual(user.subscription, subscription)
    }
    
    func testUserWithOptionalFields() {
        // Given & When
        let user = User(
            id: UUID(),
            email: nil,
            name: nil,
            subscription: .free
        )
        
        // Then
        XCTAssertNil(user.email)
        XCTAssertNil(user.name)
    }
    
    func testUserBuilder() {
        // Given
        let uuid = UUID()
        let builder = UserBuilder()
            .withId(uuid)
            .withEmail("custom@example.com")
            .withName("Custom User")
            .withSubscription(.premium)
        
        // When
        let user = builder.build()
        
        // Then
        XCTAssertEqual(user.id, uuid)
        XCTAssertEqual(user.email, "custom@example.com")
        XCTAssertEqual(user.name, "Custom User")
        XCTAssertEqual(user.subscription, .premium)
    }
    
    func testUserFixtures() {
        // Test standard user fixture
        let standardUser = UserFixtures.standard()
        XCTAssertEqual(standardUser.email, "test@example.com")
        XCTAssertEqual(standardUser.name, "Test User")
        XCTAssertEqual(standardUser.subscription, .free)
        
        // Test premium user fixture
        let premiumUser = UserFixtures.premium()
        XCTAssertEqual(premiumUser.email, "premium@example.com")
        XCTAssertEqual(premiumUser.subscription, .premium)
        
        // Test minimal user fixture
        let minimalUser = UserFixtures.minimal()
        XCTAssertNil(minimalUser.email)
        XCTAssertNil(minimalUser.name)
    }
    
    func testUserEquality() {
        // Given
        let id1 = UUID()
        let id2 = UUID()
        let user1 = User(id: id1, email: "user@example.com", name: "User", subscription: .free)
        let user2 = User(id: id1, email: "user@example.com", name: "User", subscription: .free)
        let user3 = User(id: id2, email: "user@example.com", name: "User", subscription: .free)
        
        // Then
        XCTAssertEqual(user1, user2)
        XCTAssertNotEqual(user1, user3)
    }
    
    func testUserAttributesInitialization() {
        // Given
        let email = "updated@example.com"
        let name = "Updated User"
        
        // When
        let attributes = UserAttributes(email: email, name: name)
        
        // Then
        XCTAssertEqual(attributes.email, email)
        XCTAssertEqual(attributes.name, name)
    }
    
    func testUserAttributesWithOptionalFields() {
        // Test with only email
        let emailOnly = UserAttributes(email: "email@example.com", name: nil)
        XCTAssertEqual(emailOnly.email, "email@example.com")
        XCTAssertNil(emailOnly.name)
        
        // Test with only name
        let nameOnly = UserAttributes(email: nil, name: "Name Only")
        XCTAssertNil(nameOnly.email)
        XCTAssertEqual(nameOnly.name, "Name Only")
    }
    
    func testUserAttributesFixtures() {
        // Test standard attributes
        let standard = UserAttributesFixtures.standard()
        XCTAssertNotNil(standard.email)
        XCTAssertNotNil(standard.name)
        
        // Test email only
        let emailOnly = UserAttributesFixtures.emailOnly()
        XCTAssertNotNil(emailOnly.email)
        XCTAssertNil(emailOnly.name)
        
        // Test name only
        let nameOnly = UserAttributesFixtures.nameOnly()
        XCTAssertNil(nameOnly.email)
        XCTAssertNotNil(nameOnly.name)
    }
    
    func testSubscriptionType() {
        // Test free subscription
        XCTAssertEqual(SubscriptionType.free.rawValue, "free")
        
        // Test premium subscription
        XCTAssertEqual(SubscriptionType.premium.rawValue, "premium")
        
        // Test initializing from raw value
        XCTAssertEqual(SubscriptionType(rawValue: "free"), .free)
        XCTAssertEqual(SubscriptionType(rawValue: "premium"), .premium)
        XCTAssertNil(SubscriptionType(rawValue: "invalid"))
    }
} 
