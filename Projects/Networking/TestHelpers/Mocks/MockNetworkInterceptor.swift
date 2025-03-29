import Foundation
@testable import Networking

/// A mock implementation of NetworkInterceptor for API client testing
public final class MockAPINetworkInterceptor: NetworkInterceptor {
    /// Tracks all the calls made to willSend
    public private(set) var willSendCalls: [(functionName: String, request: Any?)] = []
    
    /// Tracks all the calls made to didReceive
    public private(set) var didReceiveCalls: [(functionName: String, response: Any?, error: Error?)] = []
    
    /// Creates a new mock network interceptor
    public init() {}
    
    /// Reset all tracked calls
    public func reset() {
        willSendCalls = []
        didReceiveCalls = []
    }
    
    /// Called before a request is sent
    public func willSend<T>(functionName: String, request: T?) async {
        willSendCalls.append((functionName: functionName, request: request))
    }
    
    /// Called after a response is received
    public func didReceive<T>(functionName: String, response: T?, error: Error?) async {
        didReceiveCalls.append((functionName: functionName, response: response, error: error))
    }
    
    /// Check if a specific function was called
    public func wasFunctionCalled(_ name: String) -> Bool {
        return willSendCalls.contains { $0.functionName == name } ||
               didReceiveCalls.contains { $0.functionName == name }
    }
    
    /// Get the number of times a function was called
    public func callCount(for name: String) -> Int {
        let willSendCount = willSendCalls.filter { $0.functionName == name }.count
        let didReceiveCount = didReceiveCalls.filter { $0.functionName == name }.count
        return willSendCount + didReceiveCount
    }
} 
