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
            weeklyUnlocksUsed: profile.weeklyUnlocksUsed,
            provider: Self.issToProvider(user.userMetadata["iss"]?.stringValue)
        )
    }

    private static func issToProvider(_ iss: String?) -> Networking.Provider? {
        guard let iss else { return nil }

        return Provider.allCases.filter { iss.contains($0.rawValue) }.first
    }
}
