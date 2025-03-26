import Foundation
import Supabase

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
