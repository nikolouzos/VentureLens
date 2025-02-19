import Foundation
import Networking
import Supabase

public class Dependencies {
    @usableFromInline static let supabaseClient = SupabaseClient(
        supabaseURL: URL(string: EnvironmentVariables.get(key: .supabaseUrl))!,
        supabaseKey: EnvironmentVariables.get(key: .supabaseKey)
    )
    public let authentication: Authentication
    public let apiClient: APIClientProtocol

    public init(
        authentication: Authentication = ConcreteAuthentication(
            authClient: SupabaseAuthClientAdapter(
                supabaseAuthClient: Dependencies.supabaseClient.auth
            )
        ),
        apiClient: APIClientProtocol? = nil
    ) {
        self.authentication = authentication
        self.apiClient = apiClient ?? SupabaseFunctionsAdapter(
            supabaseFunctions: Dependencies.supabaseClient.functions
        )
    }
}

#if DEBUG
    public extension Dependencies {
        static let mock = Dependencies(
            authentication: AuthenticationMock()
        )
    }
#endif
