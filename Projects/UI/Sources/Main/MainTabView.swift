import Core
import Dependencies
import SwiftUI

public struct MainTabView: View {
    let dependencies: Dependencies
    let authCoordinator: any NavigationCoordinatorProtocol<AuthenticationViewState>

    public init(
        dependencies: Dependencies,
        authCoordinator: any NavigationCoordinatorProtocol<AuthenticationViewState>
    ) {
        self.dependencies = dependencies
        self.authCoordinator = authCoordinator
    }

    public var body: some View {
        TabView {
            IdeaFeedView(
                viewModel: IdeaFeedViewModel(dependencies: dependencies)
            )
            .tabItem {
                Label("Feed", systemImage: "lightbulb")
            }

            SettingsView(
                viewModel: SettingsViewModel(
                    dependencies: dependencies,
                    pushNotifications: PushNotifications(),
                    coordinator: authCoordinator
                )
            )
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
        .onAppear {
            dependencies.analytics.track(event: .appOpened)
        }
        .onDisappear {
            dependencies.analytics.track(event: .appClosed)
        }
    }
}

#if DEBUG
    #Preview {
        MainTabView(
            dependencies: Dependencies(),
            authCoordinator: NavigationCoordinator()
        )
    }
#endif
