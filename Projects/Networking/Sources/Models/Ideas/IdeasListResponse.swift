import Foundation

public struct IdeasListResponse: Codable {
    public let ideas: [Idea]
    public let currentPage: Int
    public let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case ideas
        case currentPage = "current_page"
        case totalPages = "total_pages"
    }

    public init(ideas: [Idea], currentPage: Int, totalPages: Int) {
        self.ideas = ideas
        self.currentPage = currentPage
        self.totalPages = totalPages
    }
}
