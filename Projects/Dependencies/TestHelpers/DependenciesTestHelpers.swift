import Foundation
import Networking
import Supabase
@testable import Dependencies

extension Dependencies {
    /// Creates a Dependencies instance with a mock Supabase client for testing
    /// - Returns: A Dependencies instance configured with mock clients
    public static func createWithMocks() -> Dependencies {
        let mockClient = MockSupabaseClient()
        
        return Dependencies(
            authentication: ConcreteAuthentication(
                authClient: SupabaseAuthAdapter(
                    supabaseClient: mockClient
                )
            ),
            apiClient: SupabaseFunctionsAdapter(
                supabaseFunctions: mockClient.functions()
            )
        )
    }
    
    /// Creates a Dependencies instance with a mock Supabase client for testing
    /// - Parameter mockClient: A pre-configured mock Supabase client
    /// - Returns: A Dependencies instance configured with the provided mock client
    public static func createWith(mockClient: MockSupabaseClient) -> Dependencies {
        return Dependencies(
            authentication: ConcreteAuthentication(
                authClient: SupabaseAuthAdapter(
                    supabaseClient: mockClient
                )
            ),
            apiClient: SupabaseFunctionsAdapter(
                supabaseFunctions: mockClient.functions()
            )
        )
    }
} 
