import Foundation

public struct ValidationMetrics: Codable, Sendable {
    public let prelaunchSignups: Int?
    public let pilotConversionRate: String?
    public let earlyAdopterSegments: [EarlyAdopterSegment]?

    private enum CodingKeys: String, CodingKey {
        case prelaunchSignups = "prelaunch_signups"
        case pilotConversionRate = "pilot_conversion_rate"
        case earlyAdopterSegments = "early_adopter_segments"
    }

    public init(
        prelaunchSignups: Int? = nil,
        pilotConversionRate: String? = nil,
        earlyAdopterSegments: [EarlyAdopterSegment]? = nil
    ) {
        self.prelaunchSignups = prelaunchSignups
        self.pilotConversionRate = pilotConversionRate
        self.earlyAdopterSegments = earlyAdopterSegments
    }
}

public struct EarlyAdopterSegment: Codable, Sendable {
    public let group: String?
    public let percentage: String?

    public init(group: String? = nil, percentage: String? = nil) {
        self.group = group
        self.percentage = percentage
    }
}
