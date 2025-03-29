import Foundation

// Forward declaration for NetworkInterceptor to avoid circular imports
public protocol NetworkInterceptor: Sendable {
    /// Called before a request is sent
    func willSend<T>(functionName: String, request: T?) async

    /// Called after a response is received
    func didReceive<T>(functionName: String, response: T?, error: Error?) async
}

public protocol APIClientProtocol: Sendable {
    /// The interceptors that will be notified of network activity
    var interceptors: [NetworkInterceptor] { get }

    /// Fetches data from the API
    /// - Parameter function: The function to call
    /// - Returns: The decoded response data
    func fetch<DataType: Decodable>(_ function: FunctionName) async throws -> DataType
}

extension APIClientProtocol {
    /// Notifies all interceptors before sending a request
    /// - Parameters:
    ///   - function: The function being called
    ///   - request: The request data, if any
    func notifyWillSend<T>(function: Any, request: T?) async {
        // Convert to string to avoid FunctionName dependency in NetworkInterceptor
        let functionString = String(describing: function)

        for interceptor in interceptors {
            await interceptor.willSend(functionName: functionString, request: request)
        }
    }

    /// Notifies all interceptors after receiving a response
    /// - Parameters:
    ///   - function: The function that was called
    ///   - response: The response data, if any
    ///   - error: The error that occurred, if any
    func notifyDidReceive<T>(function: Any, response: T?, error: Error?) async {
        // Convert to string to avoid FunctionName dependency in NetworkInterceptor
        let functionString = String(describing: function)

        for interceptor in interceptors {
            await interceptor.didReceive(functionName: functionString, response: response, error: error)
        }
    }
}

// Update the NetworkInterceptor protocol to match our usage
public extension NetworkInterceptor {
    /// Default no-op implementation for willSend
    func willSend<T>(functionName _: String, request _: T?) async {}

    /// Default no-op implementation for didReceive
    func didReceive<T>(functionName _: String, response _: T?, error _: Error?) async {}
}
