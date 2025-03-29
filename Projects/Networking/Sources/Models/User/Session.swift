import Foundation

public struct Session: Sendable {
    public let user: User
    public let accessToken: String

    public init(user: User, accessToken: String) {
        self.user = user
        self.accessToken = accessToken
    }
}
