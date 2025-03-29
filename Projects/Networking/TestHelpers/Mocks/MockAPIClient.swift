import Foundation
@testable import Networking

/// A mock implementation of APIClientProtocol for testing
public final class MockAPIClient: APIClientProtocol {    
    /// The interceptors for this client
    public let interceptors: [NetworkInterceptor]
    
    /// The default timeout for requests
    public let timeout: TimeInterval = 30.0
    
    /// Optional override for the response
    public var overrideResponse: (() async throws -> Any)? = nil
    
    /// Records of functions that have been called
    private(set) public var calledFunctions: [String] = []
    
    /// Parameters that were passed to functions
    private(set) public var capturedParameters: [String: Any] = [:]
    
    /// Creates a new instance of the mock API client
    public init(interceptors: [NetworkInterceptor] = []) {
        self.interceptors = interceptors
    }
    
    /// Reset the state of the mock
    public func reset() {
        overrideResponse = nil
        calledFunctions = []
        capturedParameters = [:]
    }
    
    public func fetch<DataType: Decodable>(_ function: FunctionName) async throws -> DataType {
        let functionName = String(describing: function)
        calledFunctions.append(functionName)
        capturedParameters[functionName] = ["timeout": timeout]
        
        // Notify interceptors
        await notifyWillSend(function: function, request: nil as Any?)
        
        do {
            if let overrideResponse = overrideResponse {
                let response = try await overrideResponse()
                
                guard let typedResponse = response as? DataType else {
                    let error = NSError(
                        domain: "MockAPIClient",
                        code: 1001,
                        userInfo: [
                            NSLocalizedDescriptionKey: "TypeMismatch: Expected \(DataType.self), got \(type(of: response))"
                        ]
                    )
                    await notifyDidReceive(function: function, response: nil as Any?, error: error)
                    throw error
                }
                
                await notifyDidReceive(function: function, response: typedResponse, error: nil)
                return typedResponse
            }
            
            // Provide default mock responses based on type
            if DataType.self == String.self {
                let result = "Mock String Response" as! DataType
                await notifyDidReceive(function: function, response: result, error: nil)
                return result
            } else if DataType.self == Bool.self {
                let result = true as! DataType
                await notifyDidReceive(function: function, response: result, error: nil)
                return result
            } else if DataType.self == Int.self {
                let result = 42 as! DataType
                await notifyDidReceive(function: function, response: result, error: nil)
                return result
            } else if DataType.self == Double.self {
                let result = 3.14 as! DataType
                await notifyDidReceive(function: function, response: result, error: nil)
                return result
            } else if DataType.self == Data.self {
                let result = "Mock Data".data(using: .utf8)! as! DataType
                await notifyDidReceive(function: function, response: result, error: nil)
                return result
            } else if DataType.self == [String].self {
                let result = ["item1", "item2", "item3"] as! DataType
                await notifyDidReceive(function: function, response: result, error: nil)
                return result
            } else if DataType.self == [String: String].self {
                let result = ["key1": "value1", "key2": "value2"] as! DataType
                await notifyDidReceive(function: function, response: result, error: nil)
                return result
            } else if DataType.self == URL.self {
                let result = URL(string: "https://example.com")! as! DataType
                await notifyDidReceive(function: function, response: result, error: nil)
                return result
            } else if DataType.self == Date.self {
                let result = Date() as! DataType
                await notifyDidReceive(function: function, response: result, error: nil)
                return result
            } else if DataType.self == Void.self {
                let result = () as! DataType
                await notifyDidReceive(function: function, response: nil as Any?, error: nil)
                return result
            }
            
            // For complex types, return a mock instance if one exists in the mocks registry
            if let mockValue = MockRegistry.shared.mockFor(type: DataType.self) {
                await notifyDidReceive(function: function, response: mockValue, error: nil)
                return mockValue
            }
            
            // If we couldn't provide a mock, throw an error
            let error = NSError(
                domain: "MockAPIClient",
                code: 1002,
                userInfo: [
                    NSLocalizedDescriptionKey: "No mock response defined for type \(DataType.self)"
                ]
            )
            await notifyDidReceive(function: function, response: nil as Any?, error: error)
            throw error
        } catch {
            await notifyDidReceive(function: function, response: nil as Any?, error: error)
            throw error
        }
    }
}

/// A registry for storing mock instances of complex types
public class MockRegistry {
    /// The shared instance of the registry
    public static let shared = MockRegistry()
    
    /// Dictionary mapping type identifiers to mock instances
    private var mocks: [String: Any] = [:]
    
    private init() {}
    
    /// Register a mock instance for a specific type
    /// - Parameters:
    ///   - instance: The mock instance
    ///   - type: The type to register the mock for
    public func register<T>(_ instance: T, for type: T.Type) {
        let typeKey = String(describing: type)
        mocks[typeKey] = instance
    }
    
    /// Get a mock instance for a specific type
    /// - Parameter type: The type to get a mock for
    /// - Returns: The mock instance, or nil if none is registered
    public func mockFor<T>(type: T.Type) -> T? {
        let typeKey = String(describing: type)
        return mocks[typeKey] as? T
    }
    
    /// Clear all registered mocks
    public func clear() {
        mocks = [:]
    }
} 
