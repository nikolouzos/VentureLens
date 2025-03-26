import Core
import Foundation
import Networking
import UI

final class NavigationCommand: Command {
    let user: User?
    let coordinator: NavigationCoordinator<AuthenticationViewState>

    init(user: User?, coordinator: NavigationCoordinator<AuthenticationViewState>) {
        self.user = user
        self.coordinator = coordinator
    }

    @MainActor
    func execute() async throws {
        guard let user else {
            coordinator.navigate(to: .loggedOut)
            return
        }

        if user.name == nil {
            coordinator.navigate(to: .signup)
            return
        }

        if !UserDefaults.standard.hasShownAnalyticsPermission {
            coordinator.navigate(to: .analyticsPermission)
            return
        }

        coordinator.navigate(to: .loggedIn)
    }
}
