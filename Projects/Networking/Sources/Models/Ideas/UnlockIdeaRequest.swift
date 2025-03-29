import Foundation

public struct UnlockIdeaRequest: Encodable, Sendable {
    public let ideaId: String

    public init(ideaId: String) {
        self.ideaId = ideaId
    }

    enum CodingKeys: String, CodingKey {
        case ideaId = "idea_id"
    }
}
