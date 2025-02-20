import Foundation

public struct IdeasListRequest: Encodable {
    public let page: Int
    public let pageSize: Int
    public let query: String?
    public let category: String?
    public let createdBefore: String?
    public let createdAfter: String?

    enum CodingKeys: String, CodingKey {
        case page
        case pageSize = "page_size"
        case query
        case category
        case createdBefore = "created_before"
        case createdAfter = "created_after"
    }

    public init(
        page: Int = 1,
        pageSize: Int = 10,
        query: String? = nil,
        category: String? = nil,
        createdBefore: String? = nil,
        createdAfter: String? = nil
    ) {
        self.page = page
        self.pageSize = pageSize
        self.query = query
        self.category = category
        self.createdBefore = createdBefore
        self.createdAfter = createdAfter
    }
}
