import Core
import Foundation

public struct Idea: Identifiable, Codable {
    public let id: UUID
    public let imageUrl: URL?
    public let title: String
    public let category: String
    public let summary: String
    public let fullDetails: String?
    public let isBookmarked: Bool?
    public let isPurchased: Bool?
    public let createdAt: Date
    public let report: Report?

    enum CodingKeys: String, CodingKey {
        case id
        case imageUrl = "image_url"
        case title
        case category
        case summary
        case fullDetails = "full_details"
        case isBookmarked = "is_bookmarked"
        case isPurchased = "is_purchased"
        case createdAt = "created_at"
        case report
    }

    init(
        id: UUID,
        title: String,
        imageUrl: URL? = nil,
        category: String,
        summary: String,
        fullDetails: String? = nil,
        isBookmarked: Bool? = nil,
        isPurchased: Bool? = nil,
        createdAt: Date,
        report: Report? = nil
    ) {
        self.id = id
        self.imageUrl = imageUrl
        self.title = title
        self.category = category
        self.summary = summary
        self.fullDetails = fullDetails
        self.isBookmarked = isBookmarked
        self.isPurchased = isPurchased
        self.createdAt = createdAt
        self.report = report
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        imageUrl = try container.decodeIfPresent(URL.self, forKey: .imageUrl)
        title = try container.decode(String.self, forKey: .title)
        category = try container.decode(String.self, forKey: .category)
        summary = try container.decode(String.self, forKey: .summary)
        fullDetails = try container.decodeIfPresent(String.self, forKey: .fullDetails)
        isBookmarked = try container.decodeIfPresent(Bool.self, forKey: .isBookmarked)
        isPurchased = try container.decodeIfPresent(Bool.self, forKey: .isPurchased)
        report = try container.decodeIfPresent(Report.self, forKey: .report)

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

// MARK: - Preview & Mocks

#if DEBUG

    public extension Idea {
        static var mock: Idea {
            Idea(
                id: UUID(),
                title: "AI-powered Pet Grooming Service",
                imageUrl: URL(string: "https://plus.unsplash.com/premium_vector-1723293057897-2c3aa2aa49c4?q=80&w=1800&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!,
                category: "Pet Care",
                summary: "An on-demand mobile app connecting pet owners with AI-assisted grooming robots.",
                fullDetails: "This innovative service combines the convenience of mobile apps with cutting-edge AI and robotics to revolutionize pet grooming. Users can schedule appointments, customize grooming preferences, and receive real-time updates during the grooming process. The AI-powered robots ensure consistent, high-quality grooming while minimizing stress for pets.",
                isBookmarked: true,
                isPurchased: false,
                createdAt: Date(),
                report: Report(
                    estimatedCost: "$500,000",
                    estimatedValue: "$2,000,000",
                    competitors: [
                        Competitor(name: "PetSmart"),
                        Competitor(name: "Petco"),
                        Competitor(name: "Local Groomers"),
                    ]
                )
            )
        }
    }

#endif
