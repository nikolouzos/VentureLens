import Core
import Dependencies
import Foundation
import Networking

final class AnalyticsCommand: Command {
    private let user: User?
    private let analytics: Analytics

    init(user: User?, analytics: Analytics) {
        self.user = user
        self.analytics = analytics
    }

    func execute() async throws {
        guard let uid = user?.id.uuidString else {
            return
        }
        analytics.identify(uid: uid, properties: nil)
    }
}
