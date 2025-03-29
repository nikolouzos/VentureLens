import XCTest
import DependenciesTestHelpers
@testable import Dependencies
@testable import Mixpanel

final class MixpanelPropertiesConversionTests: XCTestCase {
    
    // MARK: - Properties
    
    private var mixpanelInstance: MixpanelInstance!
    private var analytics: Analytics!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        // Initialize Mixpanel with a test token
        mixpanelInstance = Mixpanel.initialize(token: "test_conversion_token", trackAutomaticEvents: false)
        analytics = mixpanelInstance as Analytics
    }
    
    override func tearDown() {
        Mixpanel.removeInstance(name: "test_conversion_token")
        mixpanelInstance = nil
        analytics = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testBasicPropertyTypes() {
        // Given
        analytics.optIn(uid: nil)
        
        let properties: [String: Any] = [
            "string": "test string",
            "int": 42,
            "double": 3.14159,
            "bool": true,
            "date": Date(timeIntervalSince1970: 1609459200), // 2021-01-01
            "url": URL(string: "https://example.com")!
        ]
        
        // When - Use identify which calls convertToMixpanelProperties internally
        analytics.identify(uid: "test_basic_types", properties: properties)
        MixpanelHelpers.waitForTrackingQueue(mixpanelInstance)
        
        // Then - We can only verify the method doesn't crash
        XCTAssertEqual(mixpanelInstance.distinctId, "test_basic_types")
    }
    
    func testArrayPropertyTypes() {
        // Given
        analytics.optIn(uid: nil)
        
        let properties: [String: Any] = [
            "string_array": ["one", "two", "three"],
            "number_array": [1, 2, 3],
            "bool_array": [true, false, true],
            "mixed_array": ["string", 42, true, Date()]
        ]
        
        // When
        analytics.identify(uid: "test_array_types", properties: properties)
        MixpanelHelpers.waitForTrackingQueue(mixpanelInstance)
        
        // Then
        XCTAssertEqual(mixpanelInstance.distinctId, "test_array_types")
    }
    
    func testNullValues() {
        // Given
        analytics.optIn(uid: nil)
        
        let properties: [String: Any] = [
            "null_value": NSNull(),
            "valid_value": "test"
        ]
        
        // When
        analytics.identify(uid: "test_null_values", properties: properties)
        MixpanelHelpers.waitForTrackingQueue(mixpanelInstance)
        
        // Then
        XCTAssertEqual(mixpanelInstance.distinctId, "test_null_values")
    }
    
    func testEmptyProperties() {
        // Given
        analytics.optIn(uid: nil)
        
        let emptyProperties: [String: Any] = [:]
        
        // When
        analytics.identify(uid: "test_empty_properties", properties: emptyProperties)
        MixpanelHelpers.waitForTrackingQueue(mixpanelInstance)
        
        // Then
        XCTAssertEqual(mixpanelInstance.distinctId, "test_empty_properties")
    }
    
    func testNilProperties() {
        // Given - No properties
        analytics.optIn(uid: nil)
        
        // When
        analytics.identify(uid: "test_nil_properties", properties: nil)
        MixpanelHelpers.waitForTrackingQueue(mixpanelInstance)
        
        // Then
        XCTAssertEqual(mixpanelInstance.distinctId, "test_nil_properties")
    }
    
    func testUnsupportedTypes() {
        // Given
        analytics.optIn(uid: nil)
        
        class CustomClass {
            let value: String
            init(value: String) { self.value = value }
        }
        
        let properties: [String: Any] = [
            "custom_class": CustomClass(value: "test"),
            "valid_value": "This should still work"
        ]
        
        // When
        analytics.identify(uid: "test_unsupported_types", properties: properties)
        MixpanelHelpers.waitForTrackingQueue(mixpanelInstance)
        
        // Then - The method should not crash and should ignore the unsupported type
        XCTAssertEqual(mixpanelInstance.distinctId, "test_unsupported_types")
    }
    
    func testNestedCollections() {
        // Given
        analytics.optIn(uid: nil)
        
        let properties: [String: Any] = [
            "nested_array": [
                ["name": "Item 1", "value": 1],
                ["name": "Item 2", "value": 2]
            ],
            "nested_dictionary": [
                "level1": [
                    "level2": "value"
                ]
            ]
        ]
        
        // When
        analytics.identify(uid: "test_nested_collections", properties: properties)
        MixpanelHelpers.waitForTrackingQueue(mixpanelInstance)
        
        // Then - The method should handle or ignore nested collections appropriately
        XCTAssertEqual(mixpanelInstance.distinctId, "test_nested_collections")
    }
    
    func testLargePropertySet() {
        // Given
        analytics.optIn(uid: nil)
        
        var properties: [String: Any] = [:]
        
        // Create a large set of properties
        for i in 1...100 {
            properties["property_\(i)"] = "value_\(i)"
        }
        
        // When
        analytics.identify(uid: "test_large_property_set", properties: properties)
        MixpanelHelpers.waitForTrackingQueue(mixpanelInstance)
        
        // Then
        XCTAssertEqual(mixpanelInstance.distinctId, "test_large_property_set")
    }
    
    func testTrackEventWithAllPropertyTypes() {
        // Given
        let event = AnalyticsEvent.ideaViewed(
            id: "test-id",
            title: "Test Title",
            category: "Test Category"
        )
        
        // When
        analytics.track(event: event)
        
        // Then - We can only verify the method doesn't crash
    }
    
    func testTimedEventWithAllPropertyTypes() {
        // Given
        let eventName = AnalyticsEventName.ideaViewed
        let properties: [String: Any] = [
            "string": "test",
            "number": 123,
            "boolean": true,
            "date": Date(),
            "url": URL(string: "https://example.com")!,
            "array": ["item1", "item2"],
            "null": NSNull()
        ]
        
        // When
        analytics.startTimingEvent(event: eventName)
        Thread.sleep(forTimeInterval: 0.1)
        analytics.trackTimedEvent(event: eventName, additionalProperties: properties)
        
        // Then - We can only verify the method doesn't crash
    }
} 
