import Foundation
import Networking
import Supabase

// Protocol for abstracting SupabaseClient
public protocol SupabaseClientProtocol: AnyObject {
    func auth() -> SupabaseAuthClientProtocol
    func functions() -> SupabaseFunctionsClientProtocol
    
    /// Performs a query on a table or a view.
    /// - Parameter table: The table or view name to query.
    /// - Returns: A query builder instance.
    func from(_ table: String) -> SupabaseQueryBuilderProtocol
}

// Protocol for abstracting Supabase.AuthClient
public protocol SupabaseAuthClientProtocol: AnyObject {
    /// Gets the current session.
    var session: Supabase.Session { get async throws }
    
    /// Returns the current session, if any.
    var currentSession: Supabase.Session? { get }
    
    /// Returns the current user, if any.
    var currentUser: Supabase.User? { get }
    
    /// Sign in a user using an email and a magic link.
    /// - Parameter email: The user's email address.
    func signInWithOTP(email: String) async throws
    
    /// Sign in a user using an ID token issued by certain supported providers.
    /// - Parameter credentials: The credentials containing the ID token and other necessary information.
    /// - Returns: A session containing the user's information and access token.
    func signInWithIdToken(credentials: Supabase.OpenIDConnectCredentials) async throws -> Supabase.Session
    
    /// Verify an OTP sent to an email.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - token: The OTP token.
    ///   - type: The type of OTP.
    func verifyOTP(email: String, token: String, type: Supabase.EmailOTPType) async throws
    
    /// Sign out the current user.
    func signOut() async throws
    
    /// Refresh the current session.
    func refreshSession() async throws
    
    /// Update the current user's information.
    /// - Parameter user: The user attributes to update.
    func update(user: Supabase.UserAttributes) async throws
}

// Protocol for abstracting Supabase.FunctionsClient
public protocol SupabaseFunctionsClientProtocol: AnyObject {
    /// Invokes a Supabase Edge Function and decodes the response as a specific type.
    /// - Parameters:
    ///   - functionName: The name of the function to invoke.
    ///   - options: Options for the function invocation.
    ///   - decoder: The JSON decoder to use for decoding the response
    /// - Returns: The decoded response from the function.
    func invoke<T: Decodable>(
        _ functionName: String,
        options: Supabase.FunctionInvokeOptions,
        decoder: JSONDecoder
    ) async throws -> T
    
    /// Invokes a Supabase Edge Function without expecting a response.
    /// - Parameters:
    ///   - functionName: The name of the function to invoke.
    ///   - options: Options for the function invocation.
    func invoke(_ functionName: String, options: Supabase.FunctionInvokeOptions) async throws
}

// Protocol for abstracting PostgrestQueryBuilder
public protocol SupabaseQueryBuilderProtocol: AnyObject, SupabaseBuilderProtocol {
    /// Perform a SELECT query on the table or view.
    /// - Parameters:
    ///   - columns: The columns to retrieve, separated by commas.
    ///   - head: When set to true, data will not be returned.
    ///   - count: Count algorithm to use to count rows.
    /// - Returns: A filter builder for the query.
    func select(_ columns: String, head: Bool, count: CountOption?) -> SupabaseFilterBuilderProtocol
}

// Protocol for abstracting PostgrestFilterBuilder
public protocol SupabaseFilterBuilderProtocol: AnyObject, SupabaseTransformBuilderProtocol {
    /// Filter the results where a column equals a value.
    /// - Parameters:
    ///   - column: The column to filter on.
    ///   - value: The value to filter for.
    /// - Returns: The filter builder.
    func eq(_ column: String, value: Supabase.URLQueryRepresentable) -> SupabaseFilterBuilderProtocol
    
    /// Filter the results where a column does not equal a value.
    /// - Parameters:
    ///   - column: The column to filter on.
    ///   - value: The value to filter against.
    /// - Returns: The filter builder.
    func neq(_ column: String, value: Supabase.URLQueryRepresentable) -> SupabaseFilterBuilderProtocol
    
    /// Filter the results where a column is greater than a value.
    /// - Parameters:
    ///   - column: The column to filter on.
    ///   - value: The value to filter against.
    /// - Returns: The filter builder.
    func gt(_ column: String, value: Supabase.URLQueryRepresentable) -> SupabaseFilterBuilderProtocol
    
    /// Filter the results where a column is less than a value.
    /// - Parameters:
    ///   - column: The column to filter on.
    ///   - value: The value to filter against.
    /// - Returns: The filter builder.
    func lt(_ column: String, value: Supabase.URLQueryRepresentable) -> SupabaseFilterBuilderProtocol
    
    /// Filter the results where a column is greater than or equal to a value.
    /// - Parameters:
    ///   - column: The column to filter on.
    ///   - value: The value to filter against.
    /// - Returns: The filter builder.
    func gte(_ column: String, value: Supabase.URLQueryRepresentable) -> SupabaseFilterBuilderProtocol
    
    /// Filter the results where a column is less than or equal to a value.
    /// - Parameters:
    ///   - column: The column to filter on.
    ///   - value: The value to filter against.
    /// - Returns: The filter builder.
    func lte(_ column: String, value: Supabase.URLQueryRepresentable) -> SupabaseFilterBuilderProtocol
    
    /// Filter the results where a column matches a pattern.
    /// - Parameters:
    ///   - column: The column to filter on.
    ///   - pattern: The pattern to match against.
    /// - Returns: The filter builder.
    func like(_ column: String, pattern: Supabase.URLQueryRepresentable) -> SupabaseFilterBuilderProtocol
    
    /// Filter the results where a column is in a list of values.
    /// - Parameters:
    ///   - column: The column to filter on.
    ///   - values: The list of values to match against.
    /// - Returns: The filter builder.
    func `in`(_ column: String, values: [Supabase.URLQueryRepresentable]) -> SupabaseFilterBuilderProtocol
}

public protocol SupabaseTransformBuilderProtocol: AnyObject, SupabaseBuilderProtocol {
    /// Limit the result to a single row.
    /// - Returns: The filter builder.
    func single() -> SupabaseTransformBuilderProtocol
    
    /// Order the results by a column.
    /// - Parameters:
    ///   - column: The column to order by.
    ///   - ascending: Whether to order in ascending order.
    ///   - nullsFirst: Whether to put nulls first.
    /// - Returns: The filter builder.
    func order(_ column: String, ascending: Bool, nullsFirst: Bool, referencedTable: String?) -> SupabaseTransformBuilderProtocol
    
    /// Limit the number of rows returned.
    /// - Parameter count: The maximum number of rows to return.
    /// - Returns: The filter builder.
    func limit(_ count: Int, referencedTable: String?) -> SupabaseTransformBuilderProtocol
}

public protocol SupabaseBuilderProtocol: AnyObject {
    /// Executes the request and returns a response of the specified type.
    /// - Parameters:
    ///   - options: Options for querying Supabase.
    /// - Returns: A PostgrestResponse instance representing the response.
    func execute<T: Decodable>(options: FetchOptions) async throws -> Supabase.PostgrestResponse<T>
    
    /// Executes the request and returns a response of type Void.
    /// - Parameters:
    ///   - options: Options for querying Supabase.
    /// - Returns: A PostgrestResponse<Void> instance representing the response.
    func execute(options: FetchOptions) async throws -> Supabase.PostgrestResponse<Void>
}
