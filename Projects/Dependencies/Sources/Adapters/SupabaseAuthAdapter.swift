import Foundation
import Networking
import Supabase

public class SupabaseAuthAdapter: AuthClientProtocol {
    private unowned let supabaseClient: SupabaseClient

    public init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
    }

    public var session: Networking.Session? {
        get async {
            do {
                let supabaseSession = try await supabaseClient.auth.session
                return Session(
                    user: try await fetchUser(using: supabaseSession),
                    accessToken: supabaseSession.accessToken
                )
            } catch {
                return nil
            }
        }
    }

    public func signInWithOTP(email: String) async throws {
        try await supabaseClient.auth.signInWithOTP(email: email)
    }

    public func signInWithIdToken(credentials: Networking.OpenIDConnectCredentials) async throws -> Networking.Session {
        let supabaseCredentials = Supabase.OpenIDConnectCredentials(
            provider: mapProvider(credentials.provider),
            idToken: credentials.idToken,
            accessToken: credentials.accessToken
        )

        let supabaseSession = try await supabaseClient.auth.signInWithIdToken(
            credentials: supabaseCredentials
        )

        return Session(
            user: try await fetchUser(using: supabaseSession),
            accessToken: supabaseSession.accessToken
        )
    }

    public func verifyOTP(email: String, token: String) async throws {
        try await supabaseClient.auth.verifyOTP(
            email: email,
            token: token,
            type: .email
        )
    }

    public func logout() async throws {
        try await supabaseClient.auth.signOut()
    }

    public func refreshSession() async throws {
        try await supabaseClient.auth.refreshSession()
    }

    public func update(userAttributes: Networking.UserAttributes) async throws {
        try await supabaseClient.auth.update(
            user: Supabase.UserAttributes(
                email: userAttributes.email,
                data: userAttributes.data
            )
        )
    }
    
    public func deleteAccount() async throws {
        guard let accessToken = await session?.accessToken  else {
            return
        }
        
        do {
            try await supabaseClient.functions.invoke(
                "delete-account",
                options: FunctionInvokeOptions(
                    method: .get,
                    headers: [
                        "Content-Type": "application/json",
                        "Authorization": "Bearer \(accessToken)",
                    ]
                )
            )
            
            try await logout()
        } catch {
            throw error
        }
    }
    
    private func fetchUser(using session: Supabase.Session) async throws -> Networking.User {
        let profileResponse = try await supabaseClient
            .from("profiles")
            .select()
            .eq("uid", value: session.user.id)
            .single()
            .execute()
        let userProfile = try JSONDecoder().decode(UserProfileResponse.self, from: profileResponse.data)
        
        return User(user: session.user, profile: userProfile)
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
