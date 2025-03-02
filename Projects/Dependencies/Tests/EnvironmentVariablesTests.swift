import XCTest
@testable import Dependencies

final class EnvironmentVariablesTests: XCTestCase {
    func testGetEnvironmentVariable() {
        // Create a mock bundle with test info dictionary
        let mockBundle = MockBundle()
        mockBundle.mockInfoDictionary = [
            EnvironmentVariableKeys.supabaseUrl.rawValue: "https://test-supabase-url.com",
            EnvironmentVariableKeys.supabaseKey.rawValue: "test-supabase-key"
        ]
        
        let environmentVariables = EnvironmentVariables(bundle: mockBundle)
        
        // Test getting the Supabase URL
        let supabaseUrl = environmentVariables.get(key: .supabaseUrl)
        XCTAssertEqual(supabaseUrl, "https://test-supabase-url.com")
        
        // Test getting the Supabase key
        let supabaseKey = environmentVariables.get(key: .supabaseKey)
        XCTAssertEqual(supabaseKey, "test-supabase-key")
    }
    
    func testGetEnvironmentVariableReturnsNil() {
        // Create a mock bundle with empty info dictionary
        let mockBundle = MockBundle()
        mockBundle.mockInfoDictionary = [:]
        
        let environmentVariables = EnvironmentVariables(bundle: mockBundle)
        
        XCTAssertNil(environmentVariables.get(key: .supabaseUrl))
    }
}

// MARK: - Mock Bundle for Testing

class MockBundle: Bundle {
    var mockInfoDictionary: [String: Any] = [:]
    
    override func object(forInfoDictionaryKey key: String) -> Any? {
        return mockInfoDictionary[key]
    }
}
