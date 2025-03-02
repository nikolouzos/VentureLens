import Foundation
import Networking
@testable import Dependencies

public extension Dependencies {
    /// Creates a Dependencies instance with mock Supabase implementations
    /// - Parameters:
    ///   - mockAuth: Optional mock implementation of SupabaseAuthClientProtocol
    ///   - mockFunctions: Optional mock implementation of SupabaseFunctionsClientProtocol
    /// - Returns: A Dependencies instance configured with the provided mock implementations
    static func createWithMockSupabase(
        mockAuth: SupabaseAuthClientProtocol = MockSupabaseAuthClient(),
        mockFunctions: SupabaseFunctionsClientProtocol = MockSupabaseFunctionsClient()
    ) -> Dependencies {
        let mockSupabaseClient = MockSupabaseClient(
            mockAuth: mockAuth,
            mockFunctions: mockFunctions
        )
        
        return Dependencies(
            authentication: ConcreteAuthentication(
                authClient: SupabaseAuthAdapter(
                    supabaseClient: mockSupabaseClient
                )
            ),
            apiClient: SupabaseFunctionsAdapter(
                supabaseFunctions: mockSupabaseClient.functions()
            )
        )
    }
    
    /// Creates a Dependencies instance with fully mocked implementations
    /// - Returns: A Dependencies instance with mock Authentication and APIClient
    public static var mock: Dependencies {
        Dependencies(
            authentication: MockAuthentication(),
            apiClient: MockAPIClient()
        )
    }
} 
