import Foundation
import Networking
import Supabase

public class SupabaseAuthClientAdapter: AuthClientProtocol {
    private unowned let supabaseAuthClient: AuthClient

    public init(supabaseAuthClient: AuthClient) {
        self.supabaseAuthClient = supabaseAuthClient
    }

    public var session: Networking.Session? {
        get async {
            do {
                let supabaseSession = try await supabaseAuthClient.session
                return Session(
                    user: User(from: supabaseSession.user),
                    accessToken: supabaseSession.accessToken
                )
            } catch {
                return nil
            }
        }
    }

    public func signInWithOTP(email: String) async throws {
        try await supabaseAuthClient.signInWithOTP(email: email)
    }

    public func signInWithIdToken(credentials: Networking.OpenIDConnectCredentials) async throws -> Networking.Session {
        let supabaseCredentials = Supabase.OpenIDConnectCredentials(
            provider: mapProvider(credentials.provider),
            idToken: credentials.idToken,
            accessToken: credentials.accessToken
        )

        let supabaseSession = try await supabaseAuthClient.signInWithIdToken(
            credentials: supabaseCredentials
        )

        return Session(
            user: User(from: supabaseSession.user),
            accessToken: supabaseSession.accessToken
        )
    }

    public func verifyOTP(email: String, token: String) async throws {
        let response = try await supabaseAuthClient.verifyOTP(
            email: email,
            token: token,
            type: .email
        )
        print(response)
    }

    public func signOut() async throws {
        try await supabaseAuthClient.signOut()
    }

    public func refreshSession() async throws {
        try await supabaseAuthClient.refreshSession()
    }

    public func update(userAttributes: Networking.UserAttributes) async throws {
        try await supabaseAuthClient.update(
            user: Supabase.UserAttributes(
                email: userAttributes.email,
                data: userAttributes.data
            )
        )
    }

    private func mapProvider(_ provider: Networking.Provider) -> Supabase.OpenIDConnectCredentials.Provider {
        switch provider {
        case .apple:
            return .apple
        case .google:
            return .google
        }
    }
}
