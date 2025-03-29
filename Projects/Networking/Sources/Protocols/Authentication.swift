import Foundation

public protocol Authentication: Sendable {
    /// Gets the current `User`.
    var currentUser: User? { get async }

    /// Gets the `currentUser` access token.
    /// If the token has expired, it will automatically
    /// attempt to refresh it.
    var accessToken: String? { get async }

    /// - Parameter provider: The `AuthenticationProvider` containing the required authentication data
    func authenticate(with provider: AuthenticationProvider) async throws

    /// - Parameter email: The email the user used to signup
    /// - Parameter token: The 6-digit OTP the user has received on their email address
    func verifyOTP(email: String, token: String) async throws

    /// Forcefully refreshes the authentication token if it exists
    func refreshToken() async throws

    /// Updates user data
    /// Parameter userAttributes: The user attributes you would like to update
    func update(_ userAttributes: UserAttributes) async throws

    /// Logs the ``currentUser`` out
    func logout() async throws

    /// Deletes the ``currentUser`` account
    func deleteAccount() async throws
}

// For mock implementation, use MockAuthentication from NetworkingTestHelpers module
// See Projects/Networking/TestHelpers/Mocks/MockAuthentication.swift
