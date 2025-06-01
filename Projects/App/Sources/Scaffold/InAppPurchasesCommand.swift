import Core
import Dependencies
import Foundation
import Networking

final class InAppPurchasesCommand: Command {
    private let user: User?
    private let inAppPurchasesManager: InAppPurchasesManager

    init(user: User?, inAppPurchasesManager: InAppPurchasesManager) {
        self.user = user
        self.inAppPurchasesManager = inAppPurchasesManager
    }

    func execute() async throws {
        guard let uid = user?.id.uuidString else {
            return
        }

        await inAppPurchasesManager.initialize(userID: uid)
    }
}
