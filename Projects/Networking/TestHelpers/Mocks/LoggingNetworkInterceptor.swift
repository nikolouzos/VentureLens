import Foundation
@testable import Networking

/// A network interceptor that logs all requests and responses
public actor LoggingNetworkInterceptor: NetworkInterceptor {
    /// Log of all requests
    public private(set) var requestLog: [(functionName: String, request: Any?, timestamp: Date)] = []
    
    /// Log of all responses
    public private(set) var responseLog: [(functionName: String, response: Any?, error: Error?, timestamp: Date)] = []
    
    /// Custom logger function
    private let logger: ((String) -> Void)?
    
    /// Creates a new logging network interceptor
    /// - Parameter logger: Optional custom logger function
    public init(logger: ((String) -> Void)? = nil) {
        self.logger = logger
    }
    
    /// Logs a request
    public func willSend<T>(functionName: String, request: T?) async {
        requestLog.append((functionName: functionName, request: request, timestamp: Date()))
        
        let message = "🌐 Network Request - \(functionName)"
        logger?(message)
        
        if let request = request {
            let detailMessage = "Request: \(request)"
            logger?(detailMessage)
        }
    }
    
    /// Logs a response
    public func didReceive<T>(functionName: String, response: T?, error: Error?) async {
        responseLog.append((functionName: functionName, response: response, error: error, timestamp: Date()))
        
        let message = "🌐 Network Response - \(functionName)"
        logger?(message)
        
        if let response = response {
            let responseMessage = "Response: \(response)"
            logger?(responseMessage)
        }
        
        if let error = error {
            let errorMessage = "Error: \(error)"
            logger?(errorMessage)
        }
    }
    
    /// Clears all logged requests and responses
    public func clearLogs() {
        requestLog.removeAll()
        responseLog.removeAll()
    }
    
    /// Returns all requests for a specific function
    public func requests(for functionName: String) -> [Any?] {
        requestLog
            .filter { $0.functionName == functionName }
            .map { $0.request }
    }
    
    /// Returns all responses for a specific function
    public func responses(for functionName: String) -> [(response: Any?, error: Error?)] {
        responseLog
            .filter { $0.functionName == functionName }
            .map { (response: $0.response, error: $0.error) }
    }
    
    /// Checks if a specific function was called
    public func wasFunctionCalled(_ functionName: String) -> Bool {
        return requestLog.contains { $0.functionName == functionName } ||
               responseLog.contains { $0.functionName == functionName }
    }
    
    /// Gets the number of times a function was called
    public func callCount(for functionName: String) -> Int {
        let requestCount = requestLog.filter { $0.functionName == functionName }.count
        let responseCount = responseLog.filter { $0.functionName == functionName }.count
        return max(requestCount, responseCount)
    }
} 