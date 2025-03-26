import Foundation

public struct UnlockIdeaRequest: Encodable {
    let ideaId: String
    
    public init(ideaId: String) {
        self.ideaId = ideaId
    }
    
    enum CodingKeys: String, CodingKey {
        case ideaId = "idea_id"
    }
}
