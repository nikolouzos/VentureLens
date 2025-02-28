import Foundation

public struct IdeasListRequest: Encodable {
    public let page: Int
    public let pageSize: Int
    public let requestType: RequestType

    enum CodingKeys: String, CodingKey {
        case page
        case pageSize = "page_size"
        case query
        case category
        case createdBefore = "created_before"
        case createdAfter = "created_after"
        case ids
    }

    public enum RequestType {
        case filters(query: String?, category: String?, createdBefore: String?, createdAfter: String?)
        case ids(ids: [String])
    }

    public init(
        page: Int = 1,
        pageSize: Int = 10,
        requestType: RequestType
    ) {
        self.page = page
        self.pageSize = pageSize
        self.requestType = requestType
    }

    // Convenience initializer for filters
    public init(
        page: Int = 1,
        pageSize: Int = 10,
        query: String? = nil,
        category: String? = nil,
        createdBefore: String? = nil,
        createdAfter: String? = nil
    ) {
        self.init(
            page: page,
            pageSize: pageSize,
            requestType: .filters(
                query: query,
                category: category,
                createdBefore: createdBefore,
                createdAfter: createdAfter
            )
        )
    }

    // Convenience initializer for IDs
    public init(
        page: Int = 1,
        pageSize: Int = 10,
        ids: [String]
    ) {
        self.init(
            page: page,
            pageSize: pageSize,
            requestType: .ids(ids: ids)
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(page, forKey: .page)
        try container.encode(pageSize, forKey: .pageSize)

        switch requestType {
        case let .filters(query, category, createdBefore, createdAfter):
            if let query = query {
                try container.encode(query, forKey: .query)
            }
            if let category = category {
                try container.encode(category, forKey: .category)
            }
            if let createdBefore = createdBefore {
                try container.encode(createdBefore, forKey: .createdBefore)
            }
            if let createdAfter = createdAfter {
                try container.encode(createdAfter, forKey: .createdAfter)
            }

        case let .ids(ids):
            try container.encode(ids, forKey: .ids)
        }
    }
}
