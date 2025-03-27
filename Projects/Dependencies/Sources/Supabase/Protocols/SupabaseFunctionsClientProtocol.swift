import Foundation
import Supabase

public protocol SupabaseFunctionsClientProtocol: AnyObject, Sendable {
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
