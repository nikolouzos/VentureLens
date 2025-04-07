import Foundation
@testable import Networking

public enum APIError: Error {
    case mock
}

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
            
            throw APIError.mock
            
        } catch {
            await notifyDidReceive(function: function, response: nil as Any?, error: error)
            throw error
        }
    }
}
