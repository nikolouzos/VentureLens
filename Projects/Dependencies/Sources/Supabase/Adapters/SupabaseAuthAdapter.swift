import Foundation
import Networking
import Supabase

public actor SupabaseAuthAdapter: AuthClientProtocol {
    private unowned let supabaseClient: any SupabaseClientProtocol
    private var authStateSubscription: AuthStateChangeListenerRegistration?

    // The user should be fresh the first time we retrieve them
    private var shouldRefreshUser: Bool = true

    public init(supabaseClient: any SupabaseClientProtocol) {
        self.supabaseClient = supabaseClient

        Task {
            await listenToAuthStateChanges()
        }
    }

    deinit {
        authStateSubscription?.remove()
    }

    public var session: Networking.Session? {
        get async {
            do {
                let supabaseSession = try await supabaseClient.auth().session
                return try await Session(
                    user: fetchUser(using: supabaseSession),
                    accessToken: supabaseSession.accessToken
                )
            } catch {
                return nil
            }
        }
    }

    // MARK: - Operations

    public func signInAnonymously() async throws {
        try await supabaseClient.auth().signInAnonymously()
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

        return try await Session(
            user: fetchUser(using: supabaseSession),
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
        var userMetadata: [String: AnyJSON] = [:]

        if let name = userAttributes.name {
            userMetadata["name"] = .string(name)
        }

        do {
            try await supabaseClient.auth().update(
                user: Supabase.UserAttributes(
                    email: userAttributes.email,
                    data: userMetadata
                )
            )
        } catch {
            throw error
        }
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

    // MARK: - User Fetching

    private func fetchUser(using session: Supabase.Session) async throws -> Networking.User {
        async let user = shouldRefreshUser
            ? try await supabaseClient.auth().user
            : session.user

        async let profile = try await fetchProfile(for: session.user.id)

        do {
            let finalUser = try await User(user: user, profile: profile)
            shouldRefreshUser = false
            return finalUser

        } catch {
            throw error
        }
    }

    private func fetchProfile(for uid: UUID) async throws -> UserProfileResponse {
        let postgrestResponse: PostgrestResponse<UserProfileResponse> = try await supabaseClient
            .from("profiles")
            .select("*", head: false, count: nil)
            .eq("uid", value: uid)
            .single()
            .execute(options: FetchOptions())

        return postgrestResponse.value
    }

    // MARK: - Helpers

    private func setShouldRefreshUser(_ shouldRefreshUser: Bool) {
        self.shouldRefreshUser = shouldRefreshUser
    }

    private func mapProvider(_ provider: Networking.Provider) -> Supabase.OpenIDConnectCredentials.Provider {
        switch provider {
        case .apple:
            .apple
        }
    }

    // MARK: - Auth State Listener

    private func listenToAuthStateChanges() async {
        authStateSubscription = await supabaseClient.auth().onAuthStateChange { [weak self] event, _ in
            switch event {
            case .userUpdated, .userDeleted, .signedOut:
                Task {
                    await self?.setShouldRefreshUser(true)
                }

            default:
                return
            }
        }
    }
}
