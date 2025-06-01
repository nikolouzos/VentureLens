import Foundation

public protocol AuthClientProtocol: Actor {
    /// The current authentication session, if any
    var session: Session? { get async }

    /// Signs in a user anonymously
    func signInAnonymously() async throws

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
