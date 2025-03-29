import XCTest
import Combine
import DependenciesTestHelpers
@testable import Dependencies
@testable import Mixpanel

final class MixpanelConformanceTests: XCTestCase {
    
    // MARK: - Properties
    
    private var mixpanelInstance: MixpanelInstance!
    private var analytics: Analytics!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        // Initialize Mixpanel with a test token
        mixpanelInstance = Mixpanel.initialize(
            token: "test_token",
            trackAutomaticEvents: false,
            instanceName: "tests"
        )
        analytics = mixpanelInstance as Analytics
    }
    
    override func tearDown() {
        Mixpanel.removeInstance(name: "tests")
        mixpanelInstance = nil
        analytics = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testOptOut() {
        // Given
        mixpanelInstance.optInTracking()
        MixpanelHelpers.waitForTrackingQueue(mixpanelInstance)
        XCTAssertFalse(mixpanelInstance.hasOptedOutTracking(), "User should not be opted out initially")
        
        // When
        analytics.optOut()
        MixpanelHelpers.waitForTrackingQueue(mixpanelInstance)
        
        // Then
        XCTAssertTrue(mixpanelInstance.hasOptedOutTracking(), "User should be opted out after calling optOut()")
    }
    
    func testOptIn() {
        // Given
        mixpanelInstance.optOutTracking()
        MixpanelHelpers.waitForTrackingQueue(mixpanelInstance)
        XCTAssertTrue(mixpanelInstance.hasOptedOutTracking(), "User should be opted out initially")
        
        // When
        analytics.optIn(uid: "test_user_123")
        MixpanelHelpers.waitForTrackingQueue(mixpanelInstance)
        
        // Then
        XCTAssertFalse(mixpanelInstance.hasOptedOutTracking(), "User should be opted in after calling optIn()")
        XCTAssertEqual(mixpanelInstance.distinctId, "test_user_123", "Distinct ID should be set to the provided UID")
    }
    
    func testIdentify() {
        // Given
        // User needs to have opted in for identify to work
        analytics.optIn(uid: nil)
        let testUserId = "test_user_456"
        let testProperties: [String: Any] = [
            "email": "test@example.com",
            "name": "Test User",
            "age": 30
        ]
        
        // When
        analytics.identify(uid: testUserId, properties: testProperties)
        MixpanelHelpers.waitForTrackingQueue(mixpanelInstance)
        
        // Then
        XCTAssertEqual(mixpanelInstance.distinctId, testUserId, "Distinct ID should be set to the provided UID")
    }
    
    func testReset() {
        // Given
        analytics.optIn(uid: nil)
        
        let originalDistinctId = mixpanelInstance.distinctId
        analytics.identify(uid: "user_to_reset", properties: nil)
        MixpanelHelpers.waitForTrackingQueue(mixpanelInstance)
        
        XCTAssertEqual(mixpanelInstance.distinctId, "user_to_reset", "User should be identified before reset")
        
        // When
        analytics.reset()
        MixpanelHelpers.waitForTrackingQueue(mixpanelInstance)
        
        // Then
        // After reset, Mixpanel generates a new anonymous ID
        XCTAssertNotEqual(mixpanelInstance.distinctId, "user_to_reset", "Distinct ID should be changed after reset")
        XCTAssertNotEqual(mixpanelInstance.distinctId, originalDistinctId, "Distinct ID should be different from original")
    }
    
    func testTrackEvent() {
        // Given
        let event = AnalyticsEvent.appOpened
        
        // When
        analytics.track(event: event)
        
        // Then
        // Note: We can't directly verify events were tracked since they're not exposed publicly
        // This is a limitation of testing the real implementation
    }
    
    func testTrackEventWithProperties() {
        // Given
        let ideaId = "test-idea-123"
        let ideaTitle = "Test Idea"
        let ideaCategory = "Test Category"
        let event = AnalyticsEvent.ideaViewed(id: ideaId, title: ideaTitle, category: ideaCategory)
        
        // When
        analytics.track(event: event)
        
        // Then
        // We can't directly verify the event was tracked with the correct properties,
        // but we can ensure the method doesn't throw any exceptions
        // This indirectly tests the convertToMixpanelProperties function
    }
    
    func testStartTimingEvent() {
        // Given
        let eventName = AnalyticsEventName.appOpened
        
        // When
        analytics.startTimingEvent(event: eventName)
        
        // Then
        // Note: We can't directly verify timing was started since it's not exposed publicly
        // This is a limitation of testing the real implementation
    }
    
    func testTrackTimedEvent() {
        // Given
        let eventName = AnalyticsEventName.appOpened
        let additionalProperties: [String: Any] = ["source": "test"]
        
        // When
        analytics.startTimingEvent(event: eventName)
        // Simulate some time passing
        Thread.sleep(forTimeInterval: 0.1)
        analytics.trackTimedEvent(event: eventName, additionalProperties: additionalProperties)
        
        // Then
        // Note: We can't directly verify timed events were tracked since they're not exposed publicly
        // This is a limitation of testing the real implementation
    }
    
    func testTrackTimedEventWithoutAdditionalProperties() {
        // Given
        let eventName = AnalyticsEventName.appOpened
        
        // When
        analytics.startTimingEvent(event: eventName)
        // Simulate some time passing
        Thread.sleep(forTimeInterval: 0.1)
        analytics.trackTimedEvent(event: eventName, additionalProperties: nil)
        
        // Then
        // This indirectly tests that the method handles nil properties correctly
    }
    
    func testPropertyConversionWithVariousTypes() {
        // Given
        // Create properties with various types that should be handled by convertToMixpanelProperties
        analytics.optIn(uid: nil)
        
        let testProperties: [String: Any] = [
            "string": "test",
            "number": 123,
            "boolean": true,
            "date": Date(),
            "url": URL(string: "https://example.com")!,
            "array": ["item1", "item2"],
            "null": NSNull()
        ]
        
        // When
        // Use identify which calls convertToMixpanelProperties internally
        analytics.identify(uid: "test_user_789", properties: testProperties)
        MixpanelHelpers.waitForTrackingQueue(mixpanelInstance)
        
        // Then
        // We can't directly verify the properties were converted correctly,
        // but we can ensure the method doesn't throw any exceptions
        XCTAssertEqual(mixpanelInstance.distinctId, "test_user_789", "User should be identified")
    }
    
    func testPropertyConversionWithNestedArrays() {
        // Given
        analytics.optIn(uid: nil)
        
        let testProperties: [String: Any] = [
            "nested_array": [
                ["name": "Item 1", "value": 1],
                ["name": "Item 2", "value": 2]
            ]
        ]
        
        // When
        // This should not crash even though nested dictionaries aren't supported
        analytics.identify(uid: "test_user_nested", properties: testProperties)
        MixpanelHelpers.waitForTrackingQueue(mixpanelInstance)
        
        // Then
        XCTAssertEqual(mixpanelInstance.distinctId, "test_user_nested", "User should be identified")
    }
    
    func testPropertyConversionWithUnsupportedTypes() {
        // Given
        // Create a class instance that isn't a MixpanelType
        analytics.optIn(uid: nil)
        
        class UnsupportedClass {}
        let unsupported = UnsupportedClass()
        
        let testProperties: [String: Any] = [
            "supported": "This is supported",
            "unsupported": unsupported
        ]
        
        // When
        // This should not crash even with unsupported types
        analytics.identify(uid: "test_user_unsupported", properties: testProperties)
        MixpanelHelpers.waitForTrackingQueue(mixpanelInstance)
        
        // Then
        XCTAssertEqual(mixpanelInstance.distinctId, "test_user_unsupported", "User should be identified")
    }
} 
