import Foundation

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
