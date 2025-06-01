import Core
import Foundation
import Networking
import UI

@MainActor
final class NavigationCommand: Command {
    let user: User?
    let coordinator: any NavigationCoordinatorProtocol<AuthenticationViewState>

    init(
        user: User?,
        coordinator: any NavigationCoordinatorProtocol<AuthenticationViewState>
    ) {
        self.user = user
        self.coordinator = coordinator
    }

    func execute() async throws {
        guard let user else {
            coordinator.navigate(to: .loggedOut)
            return
        }

        if user.name == nil, !user.isAnonymous {
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
