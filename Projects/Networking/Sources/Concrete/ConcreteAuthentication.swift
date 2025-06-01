import Foundation

public final class ConcreteAuthentication: Authentication {
    private let authClient: AuthClientProtocol

    private var session: Session? {
        get async {
            await authClient.session
        }
    }

    public var currentUser: User? {
        get async {
            await authClient.session?.user
        }
    }

    public var accessToken: String? {
        get async {
            await session?.accessToken
        }
    }

    public init(authClient: AuthClientProtocol) {
        self.authClient = authClient
    }

    public func authenticate(with provider: AuthenticationProvider) async throws {
        switch provider {
        case .anonymous:
            try await authClient.signInAnonymously()

        case let .otp(email):
            try await authClient.signInWithOTP(email: email)

        case let .apple(identityToken, signupData):
            let session = try await authClient.signInWithIdToken(
                credentials: OpenIDConnectCredentials(
                    provider: .apple,
                    idToken: identityToken
                )
            )
            try await updateUserAfterSignup(user: session.user, signupData: signupData)
        }
    }

    public func verifyOTP(email: String, token: String) async throws {
        try await authClient.verifyOTP(email: email, token: token)
    }

    public func refreshToken() async throws {
        try await authClient.refreshSession()
    }

    public func update(_ userAttributes: UserAttributes) async throws {
        try await authClient.update(userAttributes: userAttributes)
    }

    public func logout() async throws {
        try await authClient.logout()
    }

    public func deleteAccount() async throws {
        try await authClient.deleteAccount()
    }

    private func updateUserAfterSignup(
        user: User,
        signupData: OAuthSignupData?
    ) async throws {
        guard let signupData, user.email == nil || user.email == "" else {
            return
        }

        try await update(
            UserAttributes(
                email: signupData.email,
                name: signupData.name
            )
        )
    }
}
