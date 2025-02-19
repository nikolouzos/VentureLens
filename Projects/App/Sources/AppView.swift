import Core
import Dependencies
import SwiftUI
import UI

struct AppView: View {
    @Environment(\.logger) var logger
    @StateObject var authCoordinator = NavigationCoordinator<AuthenticationViewState>()

    let dependencies: Dependencies

    init(dependencies: Dependencies = Dependencies()) {
        self.dependencies = dependencies
    }

    var body: some View {
        Group {
            switch authCoordinator.currentRoute {
            case nil:
                Text("Launch View")
                    .task(scaffold)

            case .loggedOut:
                AuthView(
                    viewModel: AuthViewModel(
                        authentication: dependencies.authentication,
                        coordinator: authCoordinator
                    )
                )

            case .loggedIn:
                MainTabView(
                    dependencies: dependencies,
                    authCoordinator: authCoordinator
                )

            case let .otp(signupEmail):
                OTPView(
                    viewModel: OTPViewModel(
                        authentication: dependencies.authentication,
                        coordinator: authCoordinator,
                        signupEmail: signupEmail
                    )
                )

            case .signup:
                Text("signup")
            }
        }
    }

    @Sendable
    private func scaffold() async {
        await checkAuthState()
    }

    private func checkAuthState() async {
        guard let user = await dependencies.authentication.currentUser else {
            authCoordinator.navigate(to: .loggedOut)
            return
        }

        if user.name == nil {
            authCoordinator.navigate(to: .signup)
        } else {
            authCoordinator.navigate(to: .loggedIn)
        }
    }
}
