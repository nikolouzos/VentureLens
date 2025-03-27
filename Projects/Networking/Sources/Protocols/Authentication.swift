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

#if DEBUG
    public enum AuthenticationError: Error {
        case mock
    }

    public final class MockAuthentication: Authentication {
        public var currentUser: User?
        public var accessToken: String?

        public init(
            currentUser: User? = nil,
            accessToken: String? = nil
        ) {
            self.currentUser = currentUser
            self.accessToken = accessToken
        }

        public func authenticate(with _: AuthenticationProvider) async throws {
            try await Task.sleep(for: .seconds(1.5))
            currentUser = User.mock
        }

        public func verifyOTP(email _: String, token _: String) {}

        public func refreshToken() async throws {
            if currentUser != nil {
                return
            }
            throw AuthenticationError.mock
        }

        public func update(_ userAttributes: UserAttributes) async throws {
            guard let user = currentUser else {
                throw AuthenticationError.mock
            }
            currentUser = User(
                id: user.id,
                email: userAttributes.email,
                name: userAttributes.name,
                subscription: user.subscription
            )
        }

        public func logout() async throws {
            try await Task.sleep(for: .seconds(1.5))
            currentUser = nil
        }

        public func deleteAccount() async throws {}
    }
#endif
