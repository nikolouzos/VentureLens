import Foundation
import Networking
import Supabase

public class SupabaseFunctionsAdapter: APIClientProtocol {
    private unowned let supabaseFunctions: SupabaseFunctionsClientProtocol
    private let decoder: JSONDecoder

    init(
        supabaseFunctions: SupabaseFunctionsClientProtocol,
        decoder: JSONDecoder = .init()
    ) {
        self.supabaseFunctions = supabaseFunctions
        self.decoder = decoder
    }

    public func fetch<DataType: Decodable>(
        _ function: FunctionName,
        accessToken: String
    ) async throws -> DataType {
        switch function {
        case .ideasFilters:
            return try await supabaseFunctions.invoke(
                "ideas-filters",
                options: FunctionInvokeOptions(
                    method: .get,
                    headers: [
                        "Content-Type": "application/json",
                        "Authorization": "Bearer \(accessToken)",
                    ]
                ),
                decoder: decoder
            )
        case let .ideasList(ideasListRequest):
            return try await supabaseFunctions.invoke(
                "ideas-list",
                options: FunctionInvokeOptions(
                    method: .post,
                    headers: [
                        "Content-Type": "application/json",
                        "Authorization": "Bearer \(accessToken)",
                    ],
                    body: JSONEncoder().encode(ideasListRequest)
                ),
                decoder: decoder
            )
        }
    }
}
