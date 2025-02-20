import Foundation

public struct IdeasFiltersResponse: Decodable {
    public let minDate: Date
    public let maxDate: Date
    public let categories: [String]
    
    enum CodingKeys: String, CodingKey {
        case minDate = "min_date"
        case maxDate = "max_date"
        case categories
    }
    
    public init(minDate: Date, maxDate: Date, categories: [String]) {
        self.minDate = minDate
        self.maxDate = maxDate
        self.categories = categories
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        categories = try container.decode([String].self, forKey: .categories)
        
        let minDateTimestamp = try container.decode(Int.self, forKey: .minDate)
        self.minDate = Date(timeIntervalSince1970: TimeInterval(minDateTimestamp) / 1000)
        
        let maxDateTimestamp = try container.decode(Int.self, forKey: .maxDate)
        self.maxDate = Date(timeIntervalSince1970: TimeInterval(maxDateTimestamp) / 1000)
    }
}
