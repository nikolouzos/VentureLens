import AppResources
import Core
import Dependencies
import Networking
import SwiftUI
import UI

struct AppView: View {
    @Environment(\.logger) var logger
    @State private var hasFinishedLaunching: Bool = false
    @StateObject var authCoordinator = NavigationCoordinator<AuthenticationViewState>()

    private let launchAnimationDuration = 1.0
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
        .navigationViewStyle(.stack)
    }

    @Sendable
    private func scaffold() async {
        let user = await dependencies.authentication.currentUser
        
        let commands: [Command] = [
            LaunchAnimationCommand(
                hasFinishedLaunching: $hasFinishedLaunching,
                animationDuration: launchAnimationDuration
            ),
            NavigationCommand(
                user: user,
                coordinator: authCoordinator
            )
        ]
        
        for command in commands {
            try? await command.execute()
        }
    }
}
