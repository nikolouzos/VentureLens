import Foundation

public struct Ethics: Codable, Sendable {
    public let risks: [Risk]?
    public let mitigations: [String]?

    public init(risks: [Risk]? = nil, mitigations: [String]? = nil) {
        self.risks = risks
        self.mitigations = mitigations
    }
}

public struct Risk: Codable, Sendable {
    public let type: String?
    public let description: String?
    public let severity: String?

    public init(type: String? = nil, description: String? = nil, severity: String? = nil) {
        self.type = type
        self.description = description
        self.severity = severity
    }
}
