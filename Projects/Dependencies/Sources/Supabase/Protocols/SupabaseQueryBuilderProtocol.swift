import Foundation
import Supabase

public protocol SupabaseQueryBuilderProtocol: AnyObject, SupabaseBuilderProtocol {
    /// Perform a SELECT query on the table or view.
    /// - Parameters:
    ///   - columns: The columns to retrieve, separated by commas.
    ///   - head: When set to true, data will not be returned.
    ///   - count: Count algorithm to use to count rows.
    /// - Returns: A filter builder for the query.
    func select(_ columns: String, head: Bool, count: CountOption?) -> SupabaseFilterBuilderProtocol
}
