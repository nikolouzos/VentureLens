import XCTest
import Networking
@testable import Dependencies
@testable import DependenciesTestHelpers
@testable import Supabase

final class SupabaseAuthAdapterTests: XCTestCase {
    
    // MARK: - Properties
    
    private var mockSupabaseClient: MockSupabaseClient!
    private var mockAuthClient: MockSupabaseAuthClient!
    private var mockFunctionsClient: MockSupabaseFunctionsClient!
    private var mockQueryBuilder: MockSupabaseQueryBuilder!
    private var authAdapter: SupabaseAuthAdapter!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        mockAuthClient = MockSupabaseAuthClient()
        mockFunctionsClient = MockSupabaseFunctionsClient()
        mockQueryBuilder = MockSupabaseQueryBuilder()
        mockSupabaseClient = MockSupabaseClient(
            mockAuth: mockAuthClient,
            mockFunctions: mockFunctionsClient,
            mockQueryBuilder: mockQueryBuilder
        )
        authAdapter = SupabaseAuthAdapter(supabaseClient: mockSupabaseClient)
    }
    
    override func tearDown() {
        mockAuthClient = nil
        mockSupabaseClient = nil
        authAdapter = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testSessionReturnsNilWhenErrorOccurs() async {
        // Configure mock to throw an error
        mockAuthClient.mockError = NSError(domain: "test", code: 1)
        
        // Get session should return nil when an error occurs
        let session = await authAdapter.session
        XCTAssertNil(session)
    }
    
    func testSessionReturnsValidSessionWhenAvailable() async throws {
        
        try setupMockUser()
        
        // Get session should return a valid session
        let session = await authAdapter.session
        
        XCTAssertNotNil(session)
        XCTAssertEqual(session?.accessToken, "test-access-token")
        XCTAssertEqual(session?.user.email, "test@example.com")
    }
    
    func testSignInWithOTP() async throws {
        // Test that signInWithOTP calls the underlying Supabase client
        let email = "test@example.com"
        
        try await authAdapter.signInWithOTP(email: email)
        
        XCTAssertTrue(mockAuthClient.signInWithOTPCalled)
        XCTAssertEqual(mockAuthClient.lastEmailUsed, email)
    }
    
    func testSignInWithIdToken() async throws {
        try setupMockUser()
        
        // Test that signInWithIdToken calls the underlying Supabase client
        let credentials = Networking.OpenIDConnectCredentials(
            provider: .apple,
            idToken: "test-id-token"
        )
        
        let session = try await authAdapter.signInWithIdToken(credentials: credentials)
        
        XCTAssertTrue(mockAuthClient.signInWithIdTokenCalled)
        XCTAssertEqual(session.accessToken, "test-access-token")
        XCTAssertEqual(session.user.email, "test@example.com")
    }
    
    func testSignInWithIdTokenThrowsError() async throws {
        let credentials = Networking.OpenIDConnectCredentials(
            provider: .apple,
            idToken: "test-id-token"
        )
        
        do {
            _ = try await authAdapter.signInWithIdToken(credentials: credentials)
            XCTFail("testSignInWithIdTokenThrowsError: This call should throw an error")
        } catch {
            XCTAssertEqual(error.localizedDescription, "No session available")
        }
    }
    
    func testVerifyOTP() async throws {
        // Test that verifyOTP calls the underlying Supabase client
        let email = "test@example.com"
        let token = "123456"
        
        try await authAdapter.verifyOTP(email: email, token: token)
        
        XCTAssertTrue(mockAuthClient.verifyOTPCalled)
        XCTAssertEqual(mockAuthClient.lastEmailUsed, email)
        XCTAssertEqual(mockAuthClient.lastTokenUsed, token)
    }
    
    func testLogout() async throws {
        // Test that logout calls the underlying Supabase client
        try await authAdapter.logout()
        
        XCTAssertTrue(mockAuthClient.signOutCalled)
    }
    
    func testRefreshSession() async throws {
        // Test that refreshSession calls the underlying Supabase client
        try await authAdapter.refreshSession()
        
        XCTAssertTrue(mockAuthClient.refreshSessionCalled)
    }
    
    func testUpdate() async throws {
        // Test that update calls the underlying Supabase client
        let userAttributes = Networking.UserAttributes(
            email: "new@example.com"
        )
        
        try await authAdapter.update(userAttributes: userAttributes)
        
        XCTAssertTrue(mockAuthClient.updateUserCalled)
        let userAttributesArgument = try XCTUnwrap(mockAuthClient.lastUserAttributesUsed)
        XCTAssertEqual(userAttributesArgument, Supabase.UserAttributes(email: "new@example.com"))
    }
    
    func testDeleteAccount() async throws {
        // Set up user
        try setupMockUser()
        
        // Test that deleteAccount calls the underlying Supabase client
        try await authAdapter.deleteAccount()
        
        XCTAssertTrue(mockFunctionsClient.invokeCalled)
        XCTAssertEqual(mockFunctionsClient.lastFunctionNameUsed, "delete-account")
    }
    
    // MARK: - Helpers
    
    @discardableResult
    func setupMockUser() throws -> Supabase.Session {
        // Configure mock to return a valid session
        let mockUser = Supabase.User(
            id: UUID(),
            appMetadata: [:],
            userMetadata: [:],
            aud: "test",
            email: "test@example.com",
            phone: nil,
            createdAt: Date(),
            confirmedAt: Date(),
            lastSignInAt: Date(),
            role: nil,
            updatedAt: Date()
        )
        
        let mockSession = Supabase.Session(
            accessToken: "test-access-token",
            tokenType: "bearer",
            expiresIn: 3600,
            expiresAt: 3600,
            refreshToken: "test-refresh-token",
            user: mockUser
        )
        
        mockAuthClient.mockSession = mockSession
        mockQueryBuilder.mockFilterBuilder.mockResponse = PostgrestResponse(
            data: try JSONEncoder().encode(mockUser),
            response: .init(),
            value: UserProfileResponse(
                uid: "mock",
                subscription: .free,
                unlockedIdeas: [],
                lastUnlockTime: nil,
                weeklyUnlocksUsed: 0
            )
        )
        
        return mockSession
    }
}
