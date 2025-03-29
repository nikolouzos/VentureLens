import XCTest
@testable import Networking
import NetworkingTestHelpers

final class AuthenticationIntegrationTests: XCTestCase {
    
    private var integrationHelper: IntegrationTestHelper!
    
    override func setUp() async throws {
        try await super.setUp()
        integrationHelper = IntegrationTestHelper()
    }
    
    override func tearDown() async throws {
        integrationHelper = nil
        try await super.tearDown()
    }
    
    // MARK: - Authentication Flow Tests
    
    func testOTPAuthenticationFlow() async throws {
        // Given a standard auth environment
        _ = await integrationHelper.setupStandardAuthEnvironment()
        
        // When performing an OTP authentication flow
        try await integrationHelper.authentication.authenticate(
            with: .otp(email: "test@example.com")
        )
        
        let isSignInWithOTP = await integrationHelper.authClient.calledMethods.contains("signInWithOTP")
        
        // Then the auth client should have been called with the right parameters
        XCTAssertTrue(isSignInWithOTP)
        let capturedParams = await integrationHelper.authClient.capturedParameters["signInWithOTP"] as? [String: Any]
        XCTAssertEqual(capturedParams?["email"] as? String, "test@example.com")
    }
    
    // MARK: - Error Handling Tests
    
    func testAuthenticationErrorHandling() async throws {
        // Given an environment configured to produce errors
        _ = await integrationHelper.setupErrorEnvironment()
        
        // When attempting to authenticate
        do {
            try await integrationHelper.authentication.authenticate(
                with: .otp(email: "test@example.com")
            )
            XCTFail("Authentication should have failed")
        } catch {
            // Then the error should be propagated correctly
            XCTAssertTrue(error is URLError)
        }
    }
} 
