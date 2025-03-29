import Foundation
@testable import Networking

/// A mock implementation of the AuthClientProtocol for testing
public actor MockAuthClient: AuthClientProtocol {
    // MARK: - Static Properties
    
    /// A default mock session for testing
    public static let mockSession = Session(
        user: User(
            id: UUID(uuidString: "48b3ebc4-039b-42b1-b676-51f5616fe1fb")!,
            email: "test@example.com",
            name: "Test User",
            subscription: .free
        ),
        accessToken: "mock-access-token"
    )
    
    // MARK: - Properties
    
    /// Current session
    public private(set) var mockSession: Session?
    
    /// The interceptors for this client
    public var interceptors: [AuthInterceptor] = []
    
    /// Flag to determine if the client should throw an error
    private var shouldThrowError = false
    
    /// The error to throw if shouldThrowError is true
    private var mockError: Error = URLError(.unknown)
    
    /// Records of methods that have been called
    public private(set) var calledMethods: [String] = []
    
    /// Parameters that were passed to methods
    public private(set) var capturedParameters: [String: Any] = [:]
    
    /// Number of sign-in attempts
    public private(set) var signInCount = 0
    
    /// Number of sign-out attempts
    public private(set) var signOutCount = 0
    
    /// Number of token refresh attempts
    public private(set) var refreshTokenCount = 0
    
    /// Number of refresh session calls
    public private(set) var refreshSessionCallCount: Int = 0
    
    /// Number of delete account calls
    public private(set) var deleteAccountCallCount: Int = 0
    
    // MARK: - Call Tracking
    
    /// Records of signInWithOTP calls
    public private(set) var signInWithOTPCalls: [String] = []
    
    /// Records of signInWithIdToken calls
    public private(set) var signInWithIdTokenCalls: [OpenIDConnectCredentials] = []
    
    /// Records of update calls
    public private(set) var updateCalls: [UserAttributes] = []
    
    // MARK: - Result Stubs
    
    /// Result to return from signInWithIdToken
    public private(set) var signInWithIdTokenResult: Result<Session, Error> = .failure(URLError(.unknown))
    
    /// Result to return from update
    public private(set) var updateResult: Result<User, Error> = .failure(URLError(.unknown))
    
    /// Helper properties to check if methods were called
    public var didCallSignInWithIdToken: Bool { !signInWithIdTokenCalls.isEmpty }
    public var didCallUpdate: Bool { !updateCalls.isEmpty }
    
    /// The last credentials passed to signInWithIdToken
    public var signInWithIdTokenCredentials: OpenIDConnectCredentials? {
        signInWithIdTokenCalls.last
    }
    
    /// The last user attributes passed to update
    public var updateUserAttributes: UserAttributes? {
        updateCalls.last
    }
    
    /// Creates a new instance of the mock auth client
    public init(session: Session? = nil) {
        self.mockSession = session
    }
    
    /// Reset the state of the mock
    public func reset() {
        shouldThrowError = false
        mockError = URLError(.unknown)
        mockSession = nil
        calledMethods = []
        capturedParameters = [:]
        signInCount = 0
        signOutCount = 0
        refreshTokenCount = 0
        refreshSessionCallCount = 0
        deleteAccountCallCount = 0
        signInWithOTPCalls = []
        signInWithIdTokenCalls = []
        updateCalls = []
        signInWithIdTokenResult = .failure(URLError(.unknown))
        updateResult = .failure(URLError(.unknown))
    }
    
    /// Set whether the client should throw errors
    /// - Parameter shouldThrow: True if operations should throw an error
    public func setShouldThrowError(_ shouldThrow: Bool) {
        self.shouldThrowError = shouldThrow
    }
    
    /// Set the error to throw
    /// - Parameter error: The error to throw when shouldThrowError is true
    public func setMockError(_ error: Error) {
        self.mockError = error
    }
    
    /// Set the mock session directly
    /// - Parameter session: The session to use
    public func setMockSession(_ session: Session) async {
        self.mockSession = session
    }
    
    /// Set the mock tokens to return
    /// - Parameters:
    ///   - accessToken: The mock access token
    ///   - refreshToken: The mock refresh token
    ///   - userId: Optional user ID
    public func setMockTokens(accessToken: String, refreshToken: String, userId: UUID? = nil) {
        let user = User(
            id: userId ?? UUID(),
            email: "test@example.com",
            name: "Test User",
            subscription: .free
        )
        
        self.mockSession = Session(user: user, accessToken: accessToken)
    }
    
    /// Records a method call
    /// - Parameters:
    ///   - methodName: The name of the method called
    ///   - parameters: Any parameters passed to the method
    private func recordCall(_ methodName: String, parameters: [String: Any] = [:]) {
        calledMethods.append(methodName)
        capturedParameters[methodName] = parameters
    }
    
    /// Checks if the client should throw an error
    private func checkShouldThrow() throws {
        if shouldThrowError {
            throw mockError
        }
    }
    
    // MARK: - AuthClientProtocol Implementation
    
    public var session: Session? {
        get async {
            return mockSession
        }
    }
    
    public func signInWithOTP(email: String) async throws {
        recordCall("signInWithOTP", parameters: ["email": email])
        signInCount += 1
        signInWithOTPCalls.append(email)
        
        await notifyWillPerform(operation: "signInWithOTP", parameters: ["email": email])
        
        do {
            try checkShouldThrow()
            await notifyDidPerform(operation: "signInWithOTP")
        } catch {
            await notifyDidPerform(operation: "signInWithOTP", error: error)
            throw error
        }
    }
    
    public func signInWithIdToken(credentials: OpenIDConnectCredentials) async throws -> Session {
        recordCall("signInWithIdToken", parameters: ["credentials": credentials])
        signInCount += 1
        signInWithIdTokenCalls.append(credentials)
        
        await notifyWillPerform(operation: "signInWithIdToken")
        
        do {
            try checkShouldThrow()
            
            switch signInWithIdTokenResult {
            case .success(let session):
                await notifyDidPerform(operation: "signInWithIdToken", result: session)
                return session
            case .failure(let error):
                await notifyDidPerform(operation: "signInWithIdToken", error: error)
                throw error
            }
        } catch {
            await notifyDidPerform(operation: "signInWithIdToken", error: error)
            throw error
        }
    }
    
    public func verifyOTP(email: String, token: String) async throws {
        recordCall("verifyOTP", parameters: ["email": email, "token": token])
        
        await notifyWillPerform(operation: "verifyOTP")
        
        do {
            try checkShouldThrow()
            await notifyDidPerform(operation: "verifyOTP")
        } catch {
            await notifyDidPerform(operation: "verifyOTP", error: error)
            throw error
        }
    }
    
    public func logout() async throws {
        recordCall("logout")
        signOutCount += 1
        
        await notifyWillPerform(operation: "logout")
        
        do {
            try checkShouldThrow()
            mockSession = nil
            await notifyDidPerform(operation: "logout")
        } catch {
            await notifyDidPerform(operation: "logout", error: error)
            throw error
        }
    }
    
    public func refreshSession() async throws {
        recordCall("refreshSession")
        refreshTokenCount += 1
        refreshSessionCallCount += 1
        
        await notifyWillPerform(operation: "refreshSession")
        
        do {
            try checkShouldThrow()
            
            // Update the session with a "refreshed" token
            if let session = mockSession {
                let newToken = "refreshed-" + session.accessToken
                mockSession = Session(user: session.user, accessToken: newToken)
            }
            
            await notifyDidPerform(operation: "refreshSession")
        } catch {
            await notifyDidPerform(operation: "refreshSession", error: error)
            throw error
        }
    }
    
    public func update(userAttributes: UserAttributes) async throws {
        recordCall("update", parameters: ["userAttributes": userAttributes])
        updateCalls.append(userAttributes)
        
        await notifyWillPerform(operation: "update")
        
        do {
            try checkShouldThrow()
            
            switch updateResult {
            case .success(let user):
                mockSession = Session(user: user, accessToken: mockSession?.accessToken ?? "")
                await notifyDidPerform(operation: "update", result: user)
            case .failure(let error):
                await notifyDidPerform(operation: "update", error: error)
                throw error
            }
        } catch {
            await notifyDidPerform(operation: "update", error: error)
            throw error
        }
    }
    
    public func deleteAccount() async throws {
        recordCall("deleteAccount")
        deleteAccountCallCount += 1
        
        await notifyWillPerform(operation: "deleteAccount")
        
        do {
            try checkShouldThrow()
            mockSession = nil
            await notifyDidPerform(operation: "deleteAccount")
        } catch {
            await notifyDidPerform(operation: "deleteAccount", error: error)
            throw error
        }
    }
    
    // Helper methods for tests not in the protocol
    
    public func getCurrentSession() async throws -> Session? {
        recordCall("getCurrentSession")
        try checkShouldThrow()
        return mockSession
    }
    
    public func getCurrentUserId() async throws -> String? {
        recordCall("getCurrentUserId")
        try checkShouldThrow()
        return mockSession?.user.id.uuidString
    }
    
    public func refreshAccessToken(refreshToken: String) async throws -> Session {
        recordCall("refreshAccessToken", parameters: ["refreshToken": refreshToken])
        refreshTokenCount += 1
        
        try checkShouldThrow()
        
        guard let session = mockSession else {
            throw URLError(.userAuthenticationRequired)
        }
        
        // Generate a new "refreshed" token
        let newAccessToken = "new-" + session.accessToken
        let newSession = Session(user: session.user, accessToken: newAccessToken)
        mockSession = newSession
        
        return newSession
    }
    
    /// Set the result to return when signInWithIdToken is called
    /// - Parameter result: The result to return (.success or .failure)
    public func setSignInWithIdTokenResult(_ result: Result<Session, Error>) {
        self.signInWithIdTokenResult = result
    }
    
    /// Set a successful session result for signInWithIdToken
    /// - Parameter session: The session to return
    public func setSignInWithIdTokenSuccess(_ session: Session) {
        self.signInWithIdTokenResult = .success(session)
    }
    
    /// Set an error result for signInWithIdToken
    /// - Parameter error: The error to throw
    public func setSignInWithIdTokenFailure(_ error: Error) {
        self.signInWithIdTokenResult = .failure(error)
    }
    
    /// Set the result to return when update is called
    /// - Parameter result: The result to return (.success or .failure)
    public func setUpdateResult(_ result: Result<User, Error>) {
        self.updateResult = result
    }
    
    /// Set a successful user result for update
    /// - Parameter user: The user to return
    public func setUpdateSuccess(_ user: User) {
        self.updateResult = .success(user)
    }
    
    /// Set an error result for update
    /// - Parameter error: The error to throw
    public func setUpdateFailure(_ error: Error) {
        self.updateResult = .failure(error)
    }
} 
