import Core
import UIKit

@MainActor
final class PushNotificationsCommand: Command {
    private let application: UIApplication

    init(application: UIApplication? = nil) {
        self.application = application ?? .shared
    }

    func execute() async throws {
        application.registerForRemoteNotifications()
    }
}
