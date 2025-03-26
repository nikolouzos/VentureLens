import Foundation
import Supabase

public protocol SupabaseAuthClientProtocol: AnyObject {
    /// Gets the current session.
    var session: Supabase.Session { get async throws }

    /// Returns the current session, if any.
    var currentSession: Supabase.Session? { get }

    /// Returns the current user, if any.
    var currentUser: Supabase.User? { get }

    /// Sign in a user using an email and a magic link.
    /// - Parameter email: The user's email address.
    func signInWithOTP(email: String) async throws

    /// Sign in a user using an ID token issued by certain supported providers.
    /// - Parameter credentials: The credentials containing the ID token and other necessary information.
    /// - Returns: A session containing the user's information and access token.
    func signInWithIdToken(credentials: Supabase.OpenIDConnectCredentials) async throws -> Supabase.Session

    /// Verify an OTP sent to an email.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - token: The OTP token.
    ///   - type: The type of OTP.
    func verifyOTP(email: String, token: String, type: Supabase.EmailOTPType) async throws

    /// Sign out the current user.
    func signOut() async throws

    /// Refresh the current session.
    func refreshSession() async throws

    /// Update the current user's information.
    /// - Parameter user: The user attributes to update.
    func update(user: Supabase.UserAttributes) async throws
}
