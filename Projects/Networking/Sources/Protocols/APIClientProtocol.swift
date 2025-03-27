import Foundation

public protocol APIClientProtocol: Sendable {
    func fetch<DataType: Decodable>(
        _ function: FunctionName
    ) async throws -> DataType
}

#if DEBUG
    public final class MockAPIClient: APIClientProtocol {
        public init() {}

        public var overrideResponse: (() async throws -> Decodable)?

        public func fetch<DataType: Decodable>(
            _ function: FunctionName
        ) async throws -> DataType {
            if let overrideResponse {
                return try await overrideResponse() as! DataType
            }

            switch function {
            case .ideasList:
                return IdeasListResponse(
                    ideas: [
                        Idea.mock,
                        Idea.mock,
                        Idea.mock,
                    ],
                    currentPage: 1,
                    totalPages: 1
                ) as! DataType

            case .ideasFilters:
                return IdeasFiltersResponse(
                    minDate: Date(timeIntervalSince1970: 1_739_909_000),
                    maxDate: Date(),
                    categories: [
                        "Pet Care",
                    ]
                ) as! DataType

            case .unlockIdea:
                return UnlockIdeaResponse(
                    success: true,
                    message: "Idea unlocked successfully",
                    unlockedIdeas: [Idea.mock.id.uuidString],
                    nextUnlockAvailable: Date()
                ) as! DataType
            }
        }
    }
#endif
