import Foundation
import XCTest

/// A protocol for API client test helpers
public protocol APIClientTesting {
    /// Record of API requests made
    var requestHistory: [APIRequest] { get }
    
    /// Expected responses to return for specific functions
    var mockResponses: [String: Any] { get set }
    
    /// Errors to throw for specific functions
    var mockErrors: [String: Error] { get set }
    
    /// Global delay to apply to all requests (in seconds)
    var globalRequestDelay: TimeInterval { get set }
    
    /// Function-specific delays (in seconds)
    var requestDelays: [String: TimeInterval] { get set }
    
    /// Clear all request history
    func clearRequestHistory()
    
    /// Set a mock response for a specific function
    func setMockResponse<T>(_ response: T, for functionName: String)
    
    /// Set a mock error for a specific function
    func setMockError(_ error: Error, for functionName: String)
    
    /// Set a delay for a specific function
    func setRequestDelay(_ delay: TimeInterval, for functionName: String)
}

/// Structure representing an API request for testing
public struct APIRequest: Equatable {
    /// The name of the function called
    public let functionName: String
    
    /// Parameters provided to the function (if any)
    public let parameters: [String: Any]?
    
    /// Timestamp when the request was made
    public let timestamp: Date
    
    /// Initializes a new API request record
    public init(
        functionName: String,
        parameters: [String: Any]? = nil,
        timestamp: Date = Date()
    ) {
        self.functionName = functionName
        self.parameters = parameters
        self.timestamp = timestamp
    }
    
    public static func == (lhs: APIRequest, rhs: APIRequest) -> Bool {
        // Can't directly compare [String: Any] dictionaries, so we'll just compare function names and timestamps
        lhs.functionName == rhs.functionName && lhs.timestamp == rhs.timestamp
    }
}

/// Helps verify API requests in tests
public struct APIRequestVerifier {
    /// The request history to verify
    private let requestHistory: [APIRequest]
    
    /// Initializes a new API request verifier
    public init(requestHistory: [APIRequest]) {
        self.requestHistory = requestHistory
    }
    
    /// Verifies that a specific function was called
    public func verify(functionCalled functionName: String) -> Bool {
        requestHistory.contains { $0.functionName == functionName }
    }
    
    /// Verifies that a specific function was called with specific parameters
    public func verify(
        functionCalled functionName: String,
        withParameterNamed paramName: String,
        havingValue expectedValue: Any
    ) -> Bool {
        requestHistory.contains { request in
            guard request.functionName == functionName,
                  let parameters = request.parameters,
                  let value = parameters[paramName] else {
                return false
            }
            
            // Converting to strings for comparison since we can't directly compare Any values
            return String(describing: value) == String(describing: expectedValue)
        }
    }
    
    /// Verifies that calls were made in a specific order
    public func verify(callsInOrder functionNames: [String]) -> Bool {
        let actualFunctionNames = requestHistory.map { $0.functionName }
        
        // Check if the function names array contains the specified sequence in order
        var currentIndex = 0
        var matchedCount = 0
        
        for name in actualFunctionNames {
            if name == functionNames[currentIndex] {
                matchedCount += 1
                currentIndex += 1
                
                if matchedCount == functionNames.count {
                    return true
                }
            }
        }
        
        return false
    }
    
    /// Verifies the call count for a specific function
    public func verify(callCount count: Int, for functionName: String) -> Bool {
        let actualCount = requestHistory.filter { $0.functionName == functionName }.count
        return actualCount == count
    }
} 