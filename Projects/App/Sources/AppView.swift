import Core
import Dependencies
import Networking
import SwiftUI
import UI

struct AppView: View {
    @Environment(\.logger) var logger
    @State private var hasFinishedLaunching: Bool = false
    @StateObject var authCoordinator = NavigationCoordinator<AuthenticationViewState>()

    private let launchAnimationDuration = 0.5
    private let dependencies: Dependencies

    init(dependencies: Dependencies = Dependencies()) {
        self.dependencies = dependencies
    }

    var body: some View {
        Group {
            switch authCoordinator.currentRoute {
            case nil:
                SplashView(
                    hasFinishedLaunching: $hasFinishedLaunching,
                    animationDuration: launchAnimationDuration
                )
                .task { await scaffold() }

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
                SignupView(
                    viewModel: SignupViewModel(
                        authentication: dependencies.authentication,
                        coordinator: authCoordinator
                    )
                )

            case .analyticsPermission:
                AnalyticsPermissionView(
                    viewModel: AnalyticsPermissionViewModel(
                        analytics: dependencies.analytics,
                        authentication: dependencies.authentication,
                        coordinator: authCoordinator
                    )
                )
            }
        }
        .navigationViewStyle(.stack)
    }

    private func scaffold() async {
        Task { [self] in
            let user = await dependencies.authentication.currentUser

            let commands: [Command] = [
                AppearanceCommand(),
                LaunchAnimationCommand(
                    hasFinishedLaunching: $hasFinishedLaunching,
                    animationDuration: launchAnimationDuration
                ),
                NavigationCommand(
                    user: user,
                    coordinator: authCoordinator
                ),
            ]

            for command in commands {
                try? await command.execute()
            }
        }
    }
}
