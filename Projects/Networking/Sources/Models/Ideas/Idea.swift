import Core
import Foundation

public struct Idea: Identifiable, Decodable, Sendable {
    public let id: UUID
    public let imageUrl: URL?
    public let title: String
    public let category: String
    public let summary: String
    public let fullDetails: String?
    public let createdAt: Date
    public let report: Report?
    public let ethics: Ethics?
    public let techStack: [TechStackComponent]?
    public let validationMetrics: ValidationMetrics?

    enum CodingKeys: String, CodingKey {
        case id
        case imageUrl = "image_url"
        case title
        case category
        case summary
        case fullDetails = "full_details"
        case createdAt = "created_at"
        case report
        case ethics
        case techStack = "tech_stack"
        case validationMetrics = "validation_metrics"
    }

    public init(
        id: UUID,
        title: String,
        imageUrl: URL? = nil,
        category: String,
        summary: String,
        fullDetails: String? = nil,
        createdAt: Date,
        report: Report? = nil,
        ethics: Ethics? = nil,
        techStack: [TechStackComponent]? = nil,
        validationMetrics: ValidationMetrics? = nil
    ) {
        self.id = id
        self.imageUrl = imageUrl
        self.title = title
        self.category = category
        self.summary = summary
        self.fullDetails = fullDetails
        self.createdAt = createdAt
        self.report = report
        self.ethics = ethics
        self.techStack = techStack
        self.validationMetrics = validationMetrics
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        imageUrl = try container.decodeIfPresent(URL.self, forKey: .imageUrl)
        title = try container.decode(String.self, forKey: .title)
        category = try container.decode(String.self, forKey: .category)
        summary = try container.decode(String.self, forKey: .summary)
        fullDetails = try container.decodeIfPresent(String.self, forKey: .fullDetails)
        report = try container.decodeIfPresent(Report.self, forKey: .report)
        ethics = try container.decodeIfPresent(Ethics.self, forKey: .ethics)
        techStack = try container.decodeIfPresent([TechStackComponent].self, forKey: .techStack)
        validationMetrics = try container.decodeIfPresent(ValidationMetrics.self, forKey: .validationMetrics)

        let dateString = try container.decode(String.self, forKey: .createdAt)
        guard let date = DateFormatter.server.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .createdAt,
                in: container,
                debugDescription: "Date string does not match expected format"
            )
        }
        createdAt = date
    }
}
