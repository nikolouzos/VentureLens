import Foundation

public protocol AuthClientProtocol: Actor {
    /// The current authentication session, if any
    var session: Session? { get async }
    
    /// The interceptors that will be notified of authentication operations
    var interceptors: [AuthInterceptor] { get }

    /// Initiates the sign-in process with a one-time password
    /// - Parameter email: The email address to send the OTP to
    func signInWithOTP(email: String) async throws

    /// Signs in with an OpenID Connect identity token
    /// - Parameter credentials: The OIDC credentials
    /// - Returns: The authentication session
    func signInWithIdToken(credentials: OpenIDConnectCredentials) async throws -> Session

    /// Verifies an OTP token for authentication
    /// - Parameters:
    ///   - email: The email address associated with the OTP
    ///   - token: The OTP token received by the user
    func verifyOTP(email: String, token: String) async throws

    /// Logs the current user out
    func logout() async throws

    /// Refreshes the current session's token
    func refreshSession() async throws

    /// Updates the user's profile information
    /// - Parameter userAttributes: The attributes to update
    func update(userAttributes: UserAttributes) async throws

    /// Deletes the current user's account
    func deleteAccount() async throws
}

// Protocol for auth operation interception
public protocol AuthInterceptor: Sendable {
    /// Called before an authentication operation
    /// - Parameters:
    ///   - operation: A string describing the operation
    ///   - parameters: Any parameters associated with the operation
    func willPerform(operation: String, parameters: [String: Any]?) async
    
    /// Called after an authentication operation completes
    /// - Parameters:
    ///   - operation: A string describing the operation
    ///   - result: The result of the operation, if any
    ///   - error: The error that occurred, if any
    func didPerform(operation: String, result: Any?, error: Error?) async
}

// Default implementation for auth interception
extension AuthInterceptor {
    public func willPerform(operation: String, parameters: [String: Any]?) async {}
    public func didPerform(operation: String, result: Any?, error: Error?) async {}
}

// Helper extension for AuthClientProtocol
extension AuthClientProtocol {
    /// Notifies interceptors before performing an auth operation
    internal func notifyWillPerform(operation: String, parameters: [String: Any]? = nil) async {
        for interceptor in interceptors {
            await interceptor.willPerform(operation: operation, parameters: parameters)
        }
    }
    
    /// Notifies interceptors after performing an auth operation
    internal func notifyDidPerform(operation: String, result: Any? = nil, error: Error? = nil) async {
        for interceptor in interceptors {
            await interceptor.didPerform(operation: operation, result: result, error: error)
        }
    }
}
