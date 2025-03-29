import Foundation
@testable import Networking

/// Helper for setting up integration test environments
public class IntegrationTestHelper {
    /// The mock auth client for authentication tests
    public let authClient: MockAuthClient
    
    /// The mock API client for API tests
    public let apiClient: MockAPIClient
    
    /// The authentication service for authentication tests
    public lazy var authentication: ConcreteAuthentication = {
        ConcreteAuthentication(
            authClient: authClient
        )
    }()
    
    /// Initializes a new integration test helper
    public init() {
        self.authClient = MockAuthClient()
        self.apiClient = MockAPIClient()
    }
    
    /// Reset the state of all mocks
    public func reset() async {
        await authClient.reset()
        apiClient.reset()
    }
    
    /// Set up standard authentication test environment
    /// - Returns: The configured test environment
    public func setupStandardAuthEnvironment() async -> Self {
        await reset()
        
        // Set up successful authentication with standard user
        let user = UserFixtures.standard()
        let mockSession = Session(user: user, accessToken: "test-access-token")
        await authClient.setMockSession(mockSession)
        
        return self
    }
    
    /// Set up error test environment
    /// - Parameter error: The error to use in tests
    /// - Returns: The configured test environment
    public func setupErrorEnvironment(error: Error = URLError(.notConnectedToInternet)) async -> Self {
        await reset()
        
        // Configure clients to throw errors
        await authClient.setShouldThrowError(true)
        await authClient.setMockError(error)
        
        return self
    }
    
    /// Create a test user with the given attributes
    /// - Parameters:
    ///   - id: The user ID
    ///   - email: The user's email
    ///   - name: The user's name
    ///   - premium: Whether the user has a premium subscription
    /// - Returns: The test user
    public func createTestUser(
        id: UUID = UUID(),
        email: String? = "test@example.com",
        name: String? = "Test User",
        premium: Bool = false
    ) -> User {
        let subscription: SubscriptionType = premium ? .premium : .free
        
        return User(
            id: id,
            email: email,
            name: name,
            subscription: subscription
        )
    }
} 
