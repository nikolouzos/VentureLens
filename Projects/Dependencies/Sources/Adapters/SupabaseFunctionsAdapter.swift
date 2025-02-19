import Foundation
import Networking
import Supabase

public class SupabaseFunctionsAdapter: APIClientProtocol {
    private unowned let supabaseFunctions: Supabase.FunctionsClient

    init(supabaseFunctions: Supabase.FunctionsClient) {
        self.supabaseFunctions = supabaseFunctions
    }

    public func fetch<DataType: Decodable>(
        _ function: FunctionName,
        accessToken: String
    ) async throws -> DataType {
        switch function {
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
                )
            )
        }
    }
}
