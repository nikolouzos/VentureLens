import XCTest
import Networking
@testable import Dependencies
@testable import DependenciesTestHelpers

final class DependenciesTests: XCTestCase {
    
    func testDefaultInitialization() {
        // This test verifies that the default initializer creates valid instances
        // Note: This test will fail if environment variables are not set correctly
        let dependencies = Dependencies()
        
        XCTAssertNotNil(dependencies.authentication)
        XCTAssertNotNil(dependencies.apiClient)
    }
    
    func testCustomInitialization() {
        // This test verifies that the custom initializer correctly sets the properties
        let mockAuthentication = MockAuthentication()
        let mockAPIClient = MockAPIClient()
        let mockAnalytics = MockAnalytics()
        
        let dependencies = Dependencies(
            authentication: mockAuthentication,
            apiClient: mockAPIClient,
            analytics: mockAnalytics
        )
        
        XCTAssertIdentical(dependencies.authentication as? MockAuthentication, mockAuthentication)
        XCTAssertIdentical(dependencies.apiClient as? MockAPIClient, mockAPIClient)
    }
    
    func testMockDependencies() {
        // This test verifies that the mock static property returns a valid instance
        let mockDependencies = Dependencies.mock
        
        XCTAssertTrue(mockDependencies.authentication is MockAuthentication)
        XCTAssertTrue(mockDependencies.apiClient is MockAPIClient)
    }
    
    func testCreateWithMockSupabase() {
        // This test verifies that the createWithMockSupabase helper creates a valid instance
        let dependencies = Dependencies.createWithMockSupabase()
        
        XCTAssertNotNil(dependencies.authentication)
        XCTAssertNotNil(dependencies.apiClient)
        
        // Test with custom mocks
        let mockAuth = MockSupabaseAuthClient()
        let mockFunctions = MockSupabaseFunctionsClient()
        
        let customDependencies = Dependencies.createWithMockSupabase(
            mockAuth: mockAuth,
            mockFunctions: mockFunctions
        )
        
        XCTAssertNotNil(customDependencies.authentication)
        XCTAssertNotNil(customDependencies.apiClient)
    }
    
    func testCreateWithMocks() {
        // This test verifies that the createWithMocks helper creates a valid instance
        let dependencies = Dependencies.createWithMocks()
        
        XCTAssertNotNil(dependencies.authentication)
        XCTAssertNotNil(dependencies.apiClient)
    }
    
    func testCreateWithMockClient() {
        // This test verifies that the createWith helper creates a valid instance
        let mockClient = MockSupabaseClient()
        
        let dependencies = Dependencies.createWith(mockClient: mockClient)
        
        XCTAssertNotNil(dependencies.authentication)
        XCTAssertNotNil(dependencies.apiClient)
    }
} 
