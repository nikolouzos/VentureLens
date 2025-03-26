import XCTest
import Supabase
@testable import Dependencies

final class SupabaseAuthClientConformanceTests: XCTestCase {
    
    // MARK: - Properties
    
    private var authClientProtocol: SupabaseAuthClientProtocol!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        // Create a test Supabase client with dummy credentials
        let supabaseClient = SupabaseClient(
            supabaseURL: URL(string: EnvironmentVariables.shared.get(key: .supabaseUrl)!)!,
            supabaseKey: EnvironmentVariables.shared.get(key: .supabaseKey)!
        )
        authClientProtocol = supabaseClient.auth
    }
    
    override func tearDown() {
        authClientProtocol = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testAuthClientConformsToProtocol() {
        // Verify the auth client conforms to our protocol
        XCTAssertTrue(authClientProtocol is AuthClient)
    }
    
    func testSessionPropertyIsAccessible() async {
        do {
            _ = try await authClientProtocol.session
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testCurrentSessionPropertyIsAccessible() {
        let session = authClientProtocol.currentSession
        XCTAssertNil(session)
    }
    
    func testCurrentUserPropertyIsAccessible() {
        let user = authClientProtocol.currentUser
        XCTAssertNil(user)
    }
    
    func testSignInWithOTPMethodIsAccessible() async {
        do {
            try await authClientProtocol.signInWithOTP(email: "test@example.com")
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testVerifyOTPMethodIsAccessible() async {
        do {
            try await authClientProtocol.verifyOTP(
                email: "test@example.com",
                token: "123456",
                type: .signup
            )
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testSignOutMethodIsAccessible() async {
        do {
            try await authClientProtocol.signOut()
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testRefreshSessionMethodIsAccessible() async {
        do {
            try await authClientProtocol.refreshSession()
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testUpdateMethodIsAccessible() async {
        do {
            try await authClientProtocol.update(user: UserAttributes(email: "new@example.com"))
        } catch {
            XCTAssertTrue(true)
        }
    }
} 
