import Networking
import Supabase

extension Networking.User {
    init(user: Supabase.User, profile: UserProfileResponse) {
        self.init(
            id: user.id,
            email: user.email,
            name: user.userMetadata["name"]?.stringValue,
            subscription: profile.subscription,
            unlockedIdeas: profile.unlockedIdeas,
            lastUnlockTime: profile.lastUnlockTime,
            weeklyUnlocksUsed: profile.weeklyUnlocksUsed
        )
    }
}
