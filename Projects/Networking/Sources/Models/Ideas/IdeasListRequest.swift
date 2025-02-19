import Foundation

public struct IdeasListRequest: Encodable {
    let page: Int
    let pageSize: Int

    enum CodingKeys: String, CodingKey {
        case page
        case pageSize = "page_size"
    }

    public init(page: Int, pageSize: Int) {
        self.page = page
        self.pageSize = pageSize
    }
}
