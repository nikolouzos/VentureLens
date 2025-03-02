import Foundation
import Networking
import Supabase
@testable import Dependencies

// MARK: - Mock SupabaseClient

public class MockSupabaseClient: SupabaseClientProtocol {
    public var mockAuth: SupabaseAuthClientProtocol
    public var mockFunctions: SupabaseFunctionsClientProtocol
    public var mockQueryBuilder: SupabaseQueryBuilderProtocol
    
    public init(
        mockAuth: SupabaseAuthClientProtocol = MockSupabaseAuthClient(),
        mockFunctions: SupabaseFunctionsClientProtocol = MockSupabaseFunctionsClient(),
        mockQueryBuilder: SupabaseQueryBuilderProtocol = MockSupabaseQueryBuilder()
    ) {
        self.mockAuth = mockAuth
        self.mockFunctions = mockFunctions
        self.mockQueryBuilder = mockQueryBuilder
    }
    
    public func auth() -> SupabaseAuthClientProtocol {
        return mockAuth
    }
    
    public func functions() -> SupabaseFunctionsClientProtocol {
        return mockFunctions
    }
    
    public func from(_ table: String) -> SupabaseQueryBuilderProtocol {
        (mockQueryBuilder as? MockSupabaseQueryBuilder)?.lastTableQueried = table
        return mockQueryBuilder
    }
}

// MARK: - Mock SupabaseAuthClient

public class MockSupabaseAuthClient: SupabaseAuthClientProtocol {
    public var mockSession: Supabase.Session?
    public var mockError: Error?
    
    public var signInWithOTPCalled = false
    public var signInWithIdTokenCalled = false
    public var verifyOTPCalled = false
    public var signOutCalled = false
    public var refreshSessionCalled = false
    public var updateUserCalled = false
    
    public var lastEmailUsed: String?
    public var lastTokenUsed: String?
    public var lastCredentialsUsed: Supabase.OpenIDConnectCredentials?
    public var lastUserAttributesUsed: Supabase.UserAttributes?
    
    public init(
        mockSession: Supabase.Session? = nil,
        mockError: Error? = nil
    ) {
        self.mockSession = mockSession
        self.mockError = mockError
    }
    
    public var session: Supabase.Session {
        get async throws {
            if let error = mockError {
                throw error
            }
            guard let session = mockSession else {
                throw NSError(domain: "MockSupabaseAuthClient", code: 404, userInfo: [NSLocalizedDescriptionKey: "No session available"])
            }
            return session
        }
    }
    
    public var currentSession: Supabase.Session? {
        return mockSession
    }
    
    public var currentUser: Supabase.User? {
        return mockSession?.user
    }
    
    public func signInWithOTP(email: String) async throws {
        signInWithOTPCalled = true
        lastEmailUsed = email
        
        if let error = mockError {
            throw error
        }
    }
    
    public func signInWithIdToken(credentials: Supabase.OpenIDConnectCredentials) async throws -> Supabase.Session {
        signInWithIdTokenCalled = true
        lastCredentialsUsed = credentials
        
        if let error = mockError {
            throw error
        }
        
        guard let session = mockSession else {
            throw NSError(domain: "MockSupabaseAuthClient", code: 404, userInfo: [NSLocalizedDescriptionKey: "No session available"])
        }
        
        return session
    }
    
    public func verifyOTP(email: String, token: String, type: Supabase.EmailOTPType) async throws {
        verifyOTPCalled = true
        lastEmailUsed = email
        lastTokenUsed = token
        
        if let error = mockError {
            throw error
        }
    }
    
    public func signOut() async throws {
        signOutCalled = true
        
        if let error = mockError {
            throw error
        }
    }
    
    public func refreshSession() async throws {
        refreshSessionCalled = true
        
        if let error = mockError {
            throw error
        }
    }
    
    public func update(user: Supabase.UserAttributes) async throws {
        updateUserCalled = true
        lastUserAttributesUsed = user
        
        if let error = mockError {
            throw error
        }
    }
}

// MARK: - Mock SupabaseFunctionsClient

public class MockSupabaseFunctionsClient: SupabaseFunctionsClientProtocol {
    public var mockResponse: Any?
    public var mockError: Error?
    
    public var invokeCalled = false
    public var lastFunctionNameUsed: String?
    public var lastOptionsUsed: Supabase.FunctionInvokeOptions?
    public var lastDecoderUsed: JSONDecoder?
    
    public init(
        mockResponse: Any? = nil,
        mockError: Error? = nil
    ) {
        self.mockResponse = mockResponse
        self.mockError = mockError
    }
    
    public func invoke<T: Decodable>(
        _ functionName: String,
        options: Supabase.FunctionInvokeOptions,
        decoder: JSONDecoder
    ) async throws -> T {
        invokeCalled = true
        lastFunctionNameUsed = functionName
        lastOptionsUsed = options
        lastDecoderUsed = decoder
        
        if let error = mockError {
            throw error
        }
        
        guard let response = mockResponse as? T else {
            throw NSError(domain: "MockSupabaseFunctionsClient", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid response type"])
        }
        
        return response
    }
    
    public func invoke(_ functionName: String, options: Supabase.FunctionInvokeOptions) async throws {
        invokeCalled = true
        lastFunctionNameUsed = functionName
        lastOptionsUsed = options
        
        if let error = mockError {
            throw error
        }
    }
}

// MARK: - Mock SupabaseQueryBuilder

public class MockSupabaseQueryBuilder: SupabaseQueryBuilderProtocol {
    public var mockFilterBuilder: MockSupabaseFilterBuilder
    public var lastTableQueried: String?
    
    public var selectCalled = false
    public var insertCalled = false
    public var updateCalled = false
    public var deleteCalled = false
    
    public var lastColumnsSelected: String?
    public var lastHeadValue: Bool?
    public var lastCountOption: Supabase.CountOption?
    public var lastInsertValues: Any?
    public var lastUpdateValues: Any?
    public var lastReturningOption: PostgrestReturningOptions?
    
    public init(mockFilterBuilder: MockSupabaseFilterBuilder = .init()) {
        self.mockFilterBuilder = mockFilterBuilder
    }
    
    public func select(_ columns: String = "*", head: Bool = false, count: Supabase.CountOption? = nil) -> SupabaseFilterBuilderProtocol {
        selectCalled = true
        lastColumnsSelected = columns
        lastHeadValue = head
        lastCountOption = count
        return mockFilterBuilder
    }
    
    public func execute<T: Decodable>(options: FetchOptions) async throws -> Supabase.PostgrestResponse<T> {
        throw NSError(domain: "MockSupabaseQueryBuilder", code: 500, userInfo: [NSLocalizedDescriptionKey: "Not implemented"])
    }
    
    public func execute(options: FetchOptions) async throws -> Supabase.PostgrestResponse<Void> {
        throw NSError(domain: "MockSupabaseQueryBuilder", code: 500, userInfo: [NSLocalizedDescriptionKey: "Not implemented"])
    }
}

// MARK: - Mock SupabaseFilterBuilder

public class MockSupabaseFilterBuilder: SupabaseFilterBuilderProtocol {
    public var mockResponse: Any?
    public var mockError: Error?
    
    public var eqCalled = false
    public var neqCalled = false
    public var gtCalled = false
    public var ltCalled = false
    public var gteCalled = false
    public var lteCalled = false
    public var likeCalled = false
    public var inCalled = false
    public var singleCalled = false
    public var orderCalled = false
    public var limitCalled = false
    public var executeCalled = false
    
    public var lastColumnFiltered: String?
    public var lastValueFiltered: Supabase.URLQueryRepresentable?
    public var lastPatternUsed: Supabase.URLQueryRepresentable?
    public var lastValuesUsed: [Supabase.URLQueryRepresentable]?
    public var lastOrderColumn: String?
    public var lastOrderAscending: Bool?
    public var lastOrderNullsFirst: Bool?
    public var lastReferencedTable: String?
    public var lastLimitCount: Int?
    
    public init(
        mockResponse: Any? = nil,
        mockError: Error? = nil
    ) {
        self.mockResponse = mockResponse
        self.mockError = mockError
    }
    
    public func eq(_ column: String, value: Supabase.URLQueryRepresentable) -> SupabaseFilterBuilderProtocol {
        eqCalled = true
        lastColumnFiltered = column
        lastValueFiltered = value
        return self
    }
    
    public func neq(_ column: String, value: Supabase.URLQueryRepresentable) -> SupabaseFilterBuilderProtocol {
        neqCalled = true
        lastColumnFiltered = column
        lastValueFiltered = value
        return self
    }
    
    public func gt(_ column: String, value: Supabase.URLQueryRepresentable) -> SupabaseFilterBuilderProtocol {
        gtCalled = true
        lastColumnFiltered = column
        lastValueFiltered = value
        return self
    }
    
    public func lt(_ column: String, value: Supabase.URLQueryRepresentable) -> SupabaseFilterBuilderProtocol {
        ltCalled = true
        lastColumnFiltered = column
        lastValueFiltered = value
        return self
    }
    
    public func gte(_ column: String, value: Supabase.URLQueryRepresentable) -> SupabaseFilterBuilderProtocol {
        gteCalled = true
        lastColumnFiltered = column
        lastValueFiltered = value
        return self
    }
    
    public func lte(_ column: String, value: Supabase.URLQueryRepresentable) -> SupabaseFilterBuilderProtocol {
        lteCalled = true
        lastColumnFiltered = column
        lastValueFiltered = value
        return self
    }
    
    public func like(_ column: String, pattern: Supabase.URLQueryRepresentable) -> SupabaseFilterBuilderProtocol {
        likeCalled = true
        lastColumnFiltered = column
        lastPatternUsed = pattern
        return self
    }
    
    public func `in`(_ column: String, values: [Supabase.URLQueryRepresentable]) -> SupabaseFilterBuilderProtocol {
        inCalled = true
        lastColumnFiltered = column
        lastValuesUsed = values
        return self
    }
    
    public func single() -> SupabaseTransformBuilderProtocol {
        singleCalled = true
        return self
    }
    
    public func order(_ column: String, ascending: Bool = true, nullsFirst: Bool = false, referencedTable: String? = nil) -> SupabaseTransformBuilderProtocol {
        orderCalled = true
        lastOrderColumn = column
        lastOrderAscending = ascending
        lastOrderNullsFirst = nullsFirst
        lastReferencedTable = referencedTable
        return self
    }
    
    public func limit(_ count: Int, referencedTable: String? = nil) -> SupabaseTransformBuilderProtocol {
        limitCalled = true
        lastLimitCount = count
        lastReferencedTable = referencedTable
        return self
    }
    
    public func execute<T: Decodable>(options: FetchOptions) async throws -> Supabase.PostgrestResponse<T> {
        executeCalled = true
        
        if let error = mockError {
            throw error
        }
        
        guard let response = mockResponse as? Supabase.PostgrestResponse<T> else {
            throw NSError(domain: "MockSupabaseFilterBuilder", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid response type"])
        }
        
        return response
    }
    
    public func execute(options: FetchOptions) async throws -> Supabase.PostgrestResponse<Void> {
        executeCalled = true
        
        if let error = mockError {
            throw error
        }
        
        guard let response = mockResponse as? Supabase.PostgrestResponse<Void> else {
            throw NSError(domain: "MockSupabaseFilterBuilder", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid response type"])
        }
        
        return response
    }
} 
