import Foundation
import Networking
import Supabase

public class SupabaseAuthAdapter: AuthClientProtocol {
    private unowned let supabaseClient: any SupabaseClientProtocol

    public init(supabaseClient: any SupabaseClientProtocol) {
        self.supabaseClient = supabaseClient
    }

    public var session: Networking.Session? {
        get async {
            do {
                let supabaseSession = try await supabaseClient.auth().session
                return try Session(
                    user: await fetchUser(using: supabaseSession),
                    accessToken: supabaseSession.accessToken
                )
            } catch {
                return nil
            }
        }
    }

    public func signInWithOTP(email: String) async throws {
        try await supabaseClient.auth().signInWithOTP(email: email)
    }

    public func signInWithIdToken(credentials: Networking.OpenIDConnectCredentials) async throws -> Networking.Session {
        let supabaseCredentials = Supabase.OpenIDConnectCredentials(
            provider: mapProvider(credentials.provider),
            idToken: credentials.idToken,
            accessToken: credentials.accessToken
        )

        let supabaseSession = try await supabaseClient.auth().signInWithIdToken(
            credentials: supabaseCredentials
        )

        return try Session(
            user: await fetchUser(using: supabaseSession),
            accessToken: supabaseSession.accessToken
        )
    }

    public func verifyOTP(email: String, token: String) async throws {
        try await supabaseClient.auth().verifyOTP(
            email: email,
            token: token,
            type: .email
        )
    }

    public func logout() async throws {
        try await supabaseClient.auth().signOut()
    }

    public func refreshSession() async throws {
        try await supabaseClient.auth().refreshSession()
    }

    public func update(userAttributes: Networking.UserAttributes) async throws {
        try await supabaseClient.auth().update(
            user: Supabase.UserAttributes(
                email: userAttributes.email
            )
        )
    }

    public func deleteAccount() async throws {
        do {
            try await supabaseClient.functions().invoke(
                "delete-account",
                options: FunctionInvokeOptions(
                    method: .get
                )
            )

            try await logout()
        } catch {
            throw error
        }
    }

    private func fetchUser(using session: Supabase.Session) async throws -> Networking.User {
        let profileResponse: PostgrestResponse<UserProfileResponse> = try await supabaseClient
            .from("profiles")
            .select("*", head: false, count: nil)
            .eq("uid", value: session.user.id)
            .single()
            .execute(options: FetchOptions())

        return User(user: session.user, profile: profileResponse.value)
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
