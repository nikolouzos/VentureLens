import Foundation
import Supabase

public protocol SupabaseFilterBuilderProtocol: AnyObject, SupabaseTransformBuilderProtocol {
    /// Filter the results where a column equals a value.
    /// - Parameters:
    ///   - column: The column to filter on.
    ///   - value: The value to filter for.
    /// - Returns: The filter builder.
    func eq(_ column: String, value: Supabase.PostgrestFilterValue) -> SupabaseFilterBuilderProtocol

    /// Filter the results where a column does not equal a value.
    /// - Parameters:
    ///   - column: The column to filter on.
    ///   - value: The value to filter against.
    /// - Returns: The filter builder.
    func neq(_ column: String, value: Supabase.PostgrestFilterValue) -> SupabaseFilterBuilderProtocol

    /// Filter the results where a column is greater than a value.
    /// - Parameters:
    ///   - column: The column to filter on.
    ///   - value: The value to filter against.
    /// - Returns: The filter builder.
    func gt(_ column: String, value: Supabase.PostgrestFilterValue) -> SupabaseFilterBuilderProtocol

    /// Filter the results where a column is less than a value.
    /// - Parameters:
    ///   - column: The column to filter on.
    ///   - value: The value to filter against.
    /// - Returns: The filter builder.
    func lt(_ column: String, value: Supabase.PostgrestFilterValue) -> SupabaseFilterBuilderProtocol

    /// Filter the results where a column is greater than or equal to a value.
    /// - Parameters:
    ///   - column: The column to filter on.
    ///   - value: The value to filter against.
    /// - Returns: The filter builder.
    func gte(_ column: String, value: Supabase.PostgrestFilterValue) -> SupabaseFilterBuilderProtocol

    /// Filter the results where a column is less than or equal to a value.
    /// - Parameters:
    ///   - column: The column to filter on.
    ///   - value: The value to filter against.
    /// - Returns: The filter builder.
    func lte(_ column: String, value: Supabase.PostgrestFilterValue) -> SupabaseFilterBuilderProtocol

    /// Filter the results where a column matches a pattern.
    /// - Parameters:
    ///   - column: The column to filter on.
    ///   - pattern: The pattern to match against.
    /// - Returns: The filter builder.
    func like(_ column: String, pattern: Supabase.PostgrestFilterValue) -> SupabaseFilterBuilderProtocol

    /// Filter the results where a column is in a list of values.
    /// - Parameters:
    ///   - column: The column to filter on.
    ///   - values: The list of values to match against.
    /// - Returns: The filter builder.
    func `in`(_ column: String, values: [Supabase.PostgrestFilterValue]) -> SupabaseFilterBuilderProtocol
}
