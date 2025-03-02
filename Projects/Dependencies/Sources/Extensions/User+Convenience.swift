import Networking
import Supabase

struct UserProfileResponse: Decodable {
    let uid: String
    let subscription: SubscriptionType
}

extension Networking.User {
    init(user: Supabase.User, profile: UserProfileResponse) {
        self.init(
            id: user.id,
            email: user.email,
            name: user.userMetadata["name"]?.stringValue,
            subscription: profile.subscription
        )
    }
}
