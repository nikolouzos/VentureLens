import Foundation

/// Utility for generating test data for edge cases in networking
public enum EdgeCaseTestHelper {
    
    // MARK: - Mock Response Data
    
    /// Generate an empty JSON response
    public static func emptyResponseData() -> Data {
        let json = "{}"
        return json.data(using: .utf8)!
    }
    
    /// Generate malformed JSON data for testing error handling
    public static func malformedJSONData() -> Data {
        let malformedJSON = """
        {
            "unexpected": "structure",
            "arrays": [1, "two", null],
            "nested": {"wrong": "type"}
        }
        """
        return malformedJSON.data(using: .utf8)!
    }
    
    /// Generate a JSON response with missing required fields
    public static func missingRequiredFieldsData() -> Data {
        let json = """
        {
            "id": "123",
            "optional_field": "value"
            // missing required fields
        }
        """
        return json.data(using: .utf8)!
    }
    
    /// Generate a JSON response with wrong types
    public static func wrongTypesData() -> Data {
        let json = """
        {
            "id": 123,               // should be string
            "email": true,           // should be string
            "count": "not-a-number", // should be integer
            "created_at": "invalid-date-format"
        }
        """
        return json.data(using: .utf8)!
    }
    
    // MARK: - Network Errors
    
    /// Generate common network errors for testing
    public static func networkError(for scenario: NetworkErrorScenario) -> Error {
        switch scenario {
        case .timeout:
            return URLError(.timedOut)
        case .noConnection:
            return URLError(.notConnectedToInternet)
        case .serverError:
            return URLError(.badServerResponse)
        case .cancelled:
            return URLError(.cancelled)
        }
    }
    
    /// Common network error scenarios for testing
    public enum NetworkErrorScenario {
        case timeout
        case noConnection
        case serverError
        case cancelled
    }
} 