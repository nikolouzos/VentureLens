import Foundation

public protocol SupabaseClientProtocol: AnyObject, Sendable {
    func auth() -> any SupabaseAuthClientProtocol
    func functions() -> SupabaseFunctionsClientProtocol

    /// Performs a query on a table or a view.
    /// - Parameter table: The table or view name to query.
    /// - Returns: A query builder instance.
    func from(_ table: String) -> SupabaseQueryBuilderProtocol
}
