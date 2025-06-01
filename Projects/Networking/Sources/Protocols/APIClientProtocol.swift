import Foundation

public protocol APIClientProtocol: Sendable {
    /// Fetches data from the API
    /// - Parameter function: The function to call
    /// - Returns: The decoded response data
    func fetch<DataType: Decodable>(_ function: FunctionName) async throws(Networking.HTTPError) -> DataType
}
