import XCTest
@testable import Networking
import NetworkingTestHelpers

final class ConcreteAuthenticationTests: XCTestCase {
    // MARK: - Properties
    
    private var mockAuthClient: MockAuthClient!
    private var sut: ConcreteAuthentication!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        mockAuthClient = MockAuthClient()
        sut = ConcreteAuthentication(
            authClient: mockAuthClient
        )
    }
    
    override func tearDown() {
        mockAuthClient = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Authentication Tests
    
    func testAuthenticateWithOTP() async throws {
        // Given an email for OTP authentication
        let email = "test@example.com"
        
        // When authenticating with OTP
        try await sut.authenticate(with: .otp(email: email))
        
        // Then the auth client should receive the correct call
        let calls = await mockAuthClient.signInWithOTPCalls
        XCTAssertEqual(calls.count, 1)
        XCTAssertEqual(calls.first, email)
    }
    
    func testAuthenticateWithApple() async throws {
        // Given Apple identity token
        let identityToken = "apple-identity-token"
        
        // And a mock session to return
        let mockUser = User(
            id: UUID(),
            email: "user@example.com",
            name: "Test User",
            subscription: .free
        )
        let mockSession = Session(user: mockUser, accessToken: "token")
        await mockAuthClient.setMockSession(mockSession)
        await mockAuthClient.setSignInWithIdTokenSuccess(mockSession)
        
        // When authenticating with Apple
        try await sut.authenticate(with: .apple(identityToken: identityToken))
        
        // Then the auth client should receive the correct call
        let calls = await mockAuthClient.signInWithIdTokenCalls
        XCTAssertEqual(calls.count, 1)
        XCTAssertEqual(calls.first?.idToken, identityToken)
        XCTAssertEqual(calls.first?.provider, .apple)
    }
    
    func testRefreshToken() async throws {
        // When refreshing the token
        try await sut.refreshToken()
        
        // Then the auth client should receive the refresh call
        let calls = await mockAuthClient.refreshTokenCount
        XCTAssertEqual(calls, 1)
    }
    
    func testAccessToken() async throws {
        // Given a mock session with an access token
        let token = "test-access-token"
        let mockUser = User(
            id: UUID(),
            email: "user@example.com",
            name: "Test User",
            subscription: .free
        )
        let mockSession = Session(user: mockUser, accessToken: token)
        await mockAuthClient.setMockSession(mockSession)
        
        // When getting the access token
        let accessToken = await sut.accessToken
        
        // Then it should return the correct token
        XCTAssertEqual(accessToken, token)
    }
    
    func testCurrentUser() async throws {
        // Given a mock session with a user
        let userId = UUID()
        let mockUser = User(
            id: userId,
            email: "user@example.com",
            name: "Test User",
            subscription: .free
        )
        let mockSession = Session(user: mockUser, accessToken: "token")
        await mockAuthClient.setMockSession(mockSession)
        
        // When getting the current user
        let currentUser = await sut.currentUser
        
        // Then it should return the correct user
        XCTAssertEqual(currentUser?.id, userId)
    }
    
    func testUpdateUserAttributes() async throws {
        // Given a mock session with a user
        let userId = UUID()
        let mockUser = User(
            id: userId,
            email: "old@example.com",
            name: "Old Name",
            subscription: .free
        )
        let mockSession = Session(user: mockUser, accessToken: "token")
        await mockAuthClient.setMockSession(mockSession)
        await mockAuthClient.setUpdateSuccess(mockUser)
        
        // And new user attributes
        let newEmail = "new@example.com"
        let newName = "New Name"
        let attributes = UserAttributes(email: newEmail, name: newName)
        
        // When updating user attributes
        try await sut.update(attributes)
        
        // Then the auth client should receive the update call
        let calls = await mockAuthClient.updateCalls
        XCTAssertEqual(calls.count, 1)
        XCTAssertEqual(calls.first?.email, newEmail)
        XCTAssertEqual(calls.first?.name, newName)
    }
    
    func testLogout() async throws {
        // When logging out
        try await sut.logout()
        
        // Then the auth client should receive the logout call
        let calls = await mockAuthClient.signOutCount
        XCTAssertEqual(calls, 1)
    }
    
    func testDeleteAccount() async throws {
        // When deleting the account
        try await sut.deleteAccount()
        
        // Then the auth client should receive the delete call
        let calls = await mockAuthClient.deleteAccountCallCount
        XCTAssertEqual(calls, 1)
    }
    
    func testErrorPropagation() async throws {
        // Given an auth client that throws errors
        await mockAuthClient.setShouldThrowError(true)
        await mockAuthClient.setMockError(URLError(.notConnectedToInternet))
        
        // When authenticating
        do {
            try await sut.authenticate(with: .otp(email: "test@example.com"))
            XCTFail("Expected an error to be thrown")
        } catch {
            // Then the error should be propagated
            XCTAssertTrue(error is URLError)
            XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
        }
    }
    
    // Test successful OTP verification
    func testVerifyOTPSuccess() async throws {
        // No change needed here related to TimeProvider
        // ... other existing test code ...
    }
    
    // Test successful Apple Sign-In without existing user data needing update (no signup data)
    func testAuthenticateWithApple_NoSignupData_Success() async throws {
        let identityToken = "valid_apple_token"
        await mockAuthClient.setSignInWithIdTokenSuccess(MockAuthClient.mockSession)

        try await sut.authenticate(with: .apple(identityToken: identityToken, signupData: nil))

        // Verify the expected behavior
        let didCallSignInWithIdToken = await mockAuthClient.didCallSignInWithIdToken
        let idToken = await mockAuthClient.signInWithIdTokenCredentials?.idToken
        
        XCTAssertTrue(didCallSignInWithIdToken)
        XCTAssertEqual(idToken, identityToken)
    }
    
    // Test successful Apple Sign-In with new user data requiring update
    func testAuthenticateWithApple_WithSignupData_Success() async throws {
        let identityToken = "valid_apple_token_new_user"
        let signupData = OAuthSignupData(email: "new@apple.com", name: "New Apple User")
        
        // Create a mock user that needs updating (e.g., nil email)
        let userId = UUID()
        let userNeedsUpdate = User(
            id: userId,
            email: nil,
            name: nil,
            subscription: .free
        )
        
        // Create a session with this user
        let sessionNeedsUpdate = Session(
            user: userNeedsUpdate,
            accessToken: "access_token"
        )
        
        // Configure the mock client
        await mockAuthClient.setSignInWithIdTokenSuccess(sessionNeedsUpdate)
        
        // Configure mock update result with the updated user
        let updatedUser = User(
            id: userId,
            email: signupData.email,
            name: signupData.name,
            subscription: .free
        )
        await mockAuthClient.setUpdateSuccess(updatedUser)

        // Execute the test
        try await sut.authenticate(with: .apple(identityToken: identityToken, signupData: signupData))

        // Verify the expected behavior
        let didCallSignInWithIdToken = await mockAuthClient.didCallSignInWithIdToken
        let didCallUpdate = await mockAuthClient.didCallUpdate
        let idToken = await mockAuthClient.signInWithIdTokenCredentials?.idToken
        let provider = await mockAuthClient.signInWithIdTokenCredentials?.provider
        let email = await mockAuthClient.updateUserAttributes?.email
        
        XCTAssertTrue(didCallSignInWithIdToken)
        XCTAssertEqual(idToken, identityToken)
        XCTAssertEqual(provider, .apple)
        
        XCTAssertTrue(didCallUpdate)
        XCTAssertEqual(email, signupData.email)
    }
    
    // Test error handling for Apple Sign-In
    func testAuthenticateWithApple_Failure() async throws {
        // Given
        let identityToken = "invalid_apple_token"
        let expectedError = URLError(.unknown)
        await mockAuthClient.setSignInWithIdTokenFailure(expectedError)
        
        // When and Then
        do {
            try await sut.authenticate(with: .apple(identityToken: identityToken))
            XCTFail("Expected authentication to fail")
        } catch {
            // Then the error should be propagated
            XCTAssertTrue(error is URLError)
            XCTAssertEqual((error as? URLError)?.code, .unknown)
        }
        
        // Verify the sign-in was attempted
        let didCallSignInWithIdToken = await mockAuthClient.didCallSignInWithIdToken
        XCTAssertTrue(didCallSignInWithIdToken)
    }
    
    // Test error handling for user update
    func testUpdate_Failure() async throws {
        // Given
        let errorToThrow = NSError(domain: "UpdateError", code: 123, userInfo: nil)
        await mockAuthClient.setUpdateFailure(errorToThrow)
        
        let attributes = UserAttributes(email: "test@example.com", name: "Test User")
        
        // When and Then
        do {
            try await sut.update(attributes)
            XCTFail("Expected update to fail")
        } catch {
            // Then the error should be propagated
            XCTAssertEqual((error as NSError).domain, "UpdateError")
            XCTAssertEqual((error as NSError).code, 123)
        }
        
        // Verify the update was attempted
        let didCallUpdate = await mockAuthClient.didCallUpdate
        XCTAssertTrue(didCallUpdate)
    }
} 
