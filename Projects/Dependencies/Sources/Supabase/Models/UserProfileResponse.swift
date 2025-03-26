import Foundation
import Networking

struct UserProfileResponse: Decodable {
    let uid: String
    let subscription: SubscriptionType
    let unlockedIdeas: [UUID]
    let lastUnlockTime: Date?
    let weeklyUnlocksUsed: Int

    enum CodingKeys: String, CodingKey {
        case uid
        case subscription
        case unlockedIdeas = "unlocked_ideas"
        case lastUnlockTime = "last_unlock_time"
        case weeklyUnlocksUsed = "weekly_unlocks_used"
    }
}
