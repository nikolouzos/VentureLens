import Foundation
@testable import Networking

/// Authentication error used in mocks
public enum AuthenticationError: Error {
    case mock
}

/// A mock implementation of Authentication for testing
public final class MockAuthentication: Authentication {
    /// The current user
    public var currentUser: User?
    
    /// The access token
    public var accessToken: String?
    
    /// Record of authentication calls
    private(set) public var authenticationCalls: [AuthenticationProvider] = []
    
    /// Record of OTP verification calls
    private(set) public var otpVerificationCalls: [(email: String, token: String)] = []
    
    /// Record of refresh token calls
    private(set) public var refreshTokenCalls: [Date] = []
    
    /// Record of update calls
    private(set) public var updateCalls: [UserAttributes] = []
    
    /// Record of logout calls
    private(set) public var logoutCalls: [Date] = []
    
    /// Record of delete account calls
    private(set) public var deleteAccountCalls: [Date] = []
    
    /// Flag to determine if authentication should throw an error
    public var shouldThrowOnAuthenticate = false
    
    /// Flag to determine if token refresh should throw an error
    public var shouldThrowOnRefresh = false
    
    /// Flag to determine if update should throw an error
    public var shouldThrowOnUpdate = false
    
    /// Flag to determine if logout should throw an error
    public var shouldThrowOnLogout = false
    
    /// Flag to determine if delete account should throw an error
    public var shouldThrowOnDeleteAccount = false
    
    /// Creates a new mock authentication instance
    public init(
        currentUser: User? = nil,
        accessToken: String? = nil
    ) {
        self.currentUser = currentUser
        self.accessToken = accessToken
    }
    
    /// Reset all tracking data
    public func reset() {
        authenticationCalls = []
        otpVerificationCalls = []
        refreshTokenCalls = []
        updateCalls = []
        logoutCalls = []
        deleteAccountCalls = []
        shouldThrowOnAuthenticate = false
        shouldThrowOnRefresh = false
        shouldThrowOnUpdate = false
        shouldThrowOnLogout = false
        shouldThrowOnDeleteAccount = false
    }
    
    /// Authenticate with a provider
    public func authenticate(with provider: AuthenticationProvider) async throws {
        authenticationCalls.append(provider)
        
        if shouldThrowOnAuthenticate {
            throw AuthenticationError.mock
        }
        
        try await Task.sleep(for: .seconds(0.1))
        currentUser = UserFixtures.standard()
    }
    
    /// Verify an OTP token
    public func verifyOTP(email: String, token: String) async throws {
        otpVerificationCalls.append((email: email, token: token))
    }
    
    /// Refresh the authentication token
    public func refreshToken() async throws {
        refreshTokenCalls.append(Date())
        
        if shouldThrowOnRefresh {
            throw AuthenticationError.mock
        }
        
        if currentUser == nil {
            throw AuthenticationError.mock
        }
    }
    
    /// Update user attributes
    public func update(_ userAttributes: UserAttributes) async throws {
        updateCalls.append(userAttributes)
        
        if shouldThrowOnUpdate {
            throw AuthenticationError.mock
        }
        
        guard let user = currentUser else {
            throw AuthenticationError.mock
        }
        
        currentUser = User(
            id: user.id,
            email: userAttributes.email,
            name: userAttributes.name,
            subscription: user.subscription
        )
    }
    
    /// Logout the current user
    public func logout() async throws {
        logoutCalls.append(Date())
        
        if shouldThrowOnLogout {
            throw AuthenticationError.mock
        }
        
        try await Task.sleep(for: .seconds(0.1))
        currentUser = nil
        accessToken = nil
    }
    
    /// Delete the current user's account
    public func deleteAccount() async throws {
        deleteAccountCalls.append(Date())
        
        if shouldThrowOnDeleteAccount {
            throw AuthenticationError.mock
        }
        
        currentUser = nil
        accessToken = nil
    }
} 
