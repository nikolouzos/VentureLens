import Foundation

public protocol APIClientProtocol {
    func fetch<DataType: Decodable>(
        _ function: FunctionName,
        accessToken: String
    ) async throws -> DataType
}

#if DEBUG
    public class MockAPIClient: APIClientProtocol {
        public init() {}

        public func fetch<DataType: Decodable>(
            _ function: FunctionName,
            accessToken _: String
        ) async throws -> DataType {
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
                    minDate: Date(timeIntervalSince1970: 1739909000),
                    maxDate: Date(),
                    categories: [
                        "Pet Care"
                    ]
                ) as! DataType
            }
        }
    }
#endif
