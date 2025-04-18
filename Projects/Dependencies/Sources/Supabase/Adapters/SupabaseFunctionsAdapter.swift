import Foundation
import Networking
import Supabase

public final class SupabaseFunctionsAdapter: APIClientProtocol {
    private unowned let supabaseFunctions: SupabaseFunctionsClientProtocol
    public let interceptors: [any Networking.NetworkInterceptor]
    private let decoder: JSONDecoder

    init(
        supabaseFunctions: SupabaseFunctionsClientProtocol,
        interceptors: [any Networking.NetworkInterceptor] = [],
        decoder: JSONDecoder = .init()
    ) {
        self.supabaseFunctions = supabaseFunctions
        self.interceptors = interceptors
        self.decoder = decoder
    }

    public func fetch<DataType: Decodable>(
        _ function: FunctionName
    ) async throws -> DataType {
        switch function {
        case .ideasFilters:
            return try await supabaseFunctions.invoke(
                "ideas-filters",
                options: FunctionInvokeOptions(
                    method: .get
                ),
                decoder: decoder
            )

        case let .ideasList(request):
            return try await supabaseFunctions.invoke(
                "ideas-list",
                options: FunctionInvokeOptions(
                    method: .post,
                    body: JSONEncoder().encode(request)
                ),
                decoder: decoder
            )

        case let .unlockIdea(request):
            return try await supabaseFunctions.invoke(
                "unlock-idea",
                options: FunctionInvokeOptions(
                    method: .post,
                    body: JSONEncoder().encode(request)
                ),
                decoder: decoder
            )
        }
    }
}
