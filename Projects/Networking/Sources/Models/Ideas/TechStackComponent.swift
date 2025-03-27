import Foundation

public struct TechStackComponent: Codable, Sendable {
    public let component: String?
    public let tools: [String]?

    public init(component: String? = nil, tools: [String]? = nil) {
        self.component = component
        self.tools = tools
    }
}
