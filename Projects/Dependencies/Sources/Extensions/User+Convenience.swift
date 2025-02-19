import Networking
import Supabase

extension Networking.User {
    init(from supabaseUser: Supabase.User) {
        self.init(
            id: supabaseUser.id,
            email: supabaseUser.email,
            name: supabaseUser.userMetadata["name"]?.stringValue,
            subscription: supabaseUser.userMetadata["subscription"]?.stringValue
        )
    }
}

extension Networking.UserAttributes {
    var data: [String: AnyJSON] {
        var data: [String: AnyJSON] = [:]

        if let name {
            data["name"] = .string(name)
        }

        return data
    }
}
