import Foundation

public struct Session {
    public let user: User
    public let accessToken: String

    public init(user: User, accessToken: String) {
        self.user = user
        self.accessToken = accessToken
    }
}
