import Foundation
import Networking
import Supabase

public final class SupabaseFunctionsAdapter: APIClientProtocol {
    private unowned let supabaseFunctions: SupabaseFunctionsClientProtocol
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(
        supabaseFunctions: SupabaseFunctionsClientProtocol,
        encoder: JSONEncoder = .init(),
        decoder: JSONDecoder = .init()
    ) {
        self.supabaseFunctions = supabaseFunctions
        self.encoder = encoder
        self.decoder = decoder
    }

    public func fetch<DataType: Decodable>(
        _ function: FunctionName
    ) async throws(Networking.HTTPError) -> DataType {
        do {
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
                        body: encoder.encode(request)
                    ),
                    decoder: decoder
                )

            case let .unlockIdea(request):
                return try await supabaseFunctions.invoke(
                    "unlock-idea",
                    options: FunctionInvokeOptions(
                        method: .post,
                        body: encoder.encode(request)
                    ),
                    decoder: decoder
                )
            }

        } catch let error as FunctionsError {
            switch error {
            case let .httpError(code, data):
                guard let commonError = try? decoder.decode(CommonError.self, from: data) else {
                    throw HTTPError.unknown
                }
                throw HTTPError.common(status: code, error: commonError)

            case .relayError:
                throw HTTPError.common(status: 500, error: .init(success: false, message: "Relay error"))
            }
        } catch {
            // NOOP - This shouldn't be reached
            throw HTTPError.unknown
        }
    }
}
