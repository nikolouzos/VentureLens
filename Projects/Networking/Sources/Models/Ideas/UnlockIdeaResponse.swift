import Foundation

public struct UnlockIdeaResponse: Decodable {
    public let success: Bool
    public let message: String?
    public let unlockedIdeas: [String]?
    public let nextUnlockAvailable: Date?

    public init(
        success: Bool,
        message: String?,
        unlockedIdeas: [String]?,
        nextUnlockAvailable: Date?
    ) {
        self.success = success
        self.message = message
        self.unlockedIdeas = unlockedIdeas
        self.nextUnlockAvailable = nextUnlockAvailable
    }

    enum CodingKeys: String, CodingKey {
        case success
        case message
        case unlockedIdeas = "unlocked_ideas"
        case nextUnlockAvailable = "next_unlock_available"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        message = try? container.decodeIfPresent(String.self, forKey: .message)
        unlockedIdeas = try? container.decodeIfPresent([String].self, forKey: .unlockedIdeas)
        nextUnlockAvailable = try? container.decodeIfPresent(Date.self, forKey: .nextUnlockAvailable)
    }
}
