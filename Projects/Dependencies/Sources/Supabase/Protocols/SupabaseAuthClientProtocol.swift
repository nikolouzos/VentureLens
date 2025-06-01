import Foundation
import Supabase

public protocol SupabaseAuthClientProtocol: Actor {
    associatedtype AuthStateSubscription: AuthStateChangeListenerRegistration

    /// Gets the current session.
    var session: Supabase.Session { get async throws }

    /// Get the current user (remotely)
    var user: Supabase.User { get async throws }

    /// Signs in a user anonymously
    func signInAnonymously() async throws

    /// Signs in a user using an email and a magic link.
    /// - Parameter email: The user's email address.
    func signInWithOTP(email: String) async throws

    /// Signs in a user using an ID token issued by certain supported providers.
    /// - Parameter credentials: The credentials containing the ID token and other necessary information.
    /// - Returns: A session containing the user's information and access token.
    @discardableResult
    func signInWithIdToken(credentials: Supabase.OpenIDConnectCredentials) async throws -> Supabase.Session

    /// Verifies an OTP sent to an email.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - token: The OTP token.
    ///   - type: The type of OTP.
    func verifyOTP(email: String, token: String, type: Supabase.EmailOTPType) async throws

    /// Signs out the current user.
    func signOut() async throws

    /// Refreshes the current session.
    func refreshSession() async throws

    /// Updates the current user's information.
    /// - Parameter user: The user attributes to update.
    func update(user: Supabase.UserAttributes) async throws

    /// Listens for auth state changes
    @discardableResult
    func onAuthStateChange(_ listener: @escaping AuthStateChangeListener) async -> AuthStateSubscription
}
