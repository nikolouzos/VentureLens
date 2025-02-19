import Foundation

public struct Report: Codable {
    public let estimatedCost: String
    public let estimatedValue: String
    public let competitors: [Competitor]

    public init(
        estimatedCost: String,
        estimatedValue: String,
        competitors: [Competitor]
    ) {
        self.estimatedCost = estimatedCost
        self.estimatedValue = estimatedValue
        self.competitors = competitors
    }

    private enum CodingKeys: String, CodingKey {
        case estimatedCost = "estimated_cost"
        case estimatedValue = "estimated_value"
        case competitors
    }
}

public struct Competitor: Codable {
    public let name: String
}
