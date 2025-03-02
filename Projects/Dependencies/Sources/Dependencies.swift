import Foundation
import Networking
import Supabase

public class Dependencies {
    public let authentication: Authentication
    public let apiClient: APIClientProtocol

    public convenience init() {
        let supabaseClient = SupabaseClient(
            supabaseURL: URL(string: EnvironmentVariables.shared.get(key: .supabaseUrl)!)!,
            supabaseKey: EnvironmentVariables.shared.get(key: .supabaseKey)!
        )

        self.init(
            authentication: ConcreteAuthentication(
                authClient: SupabaseAuthAdapter(
                    supabaseClient: supabaseClient
                )
            ),
            apiClient: SupabaseFunctionsAdapter(
                supabaseFunctions: supabaseClient.functions
            )
        )
    }

    public init(
        authentication: Authentication,
        apiClient: APIClientProtocol
    ) {
        self.authentication = authentication
        self.apiClient = apiClient
    }
}
