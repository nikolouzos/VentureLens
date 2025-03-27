import Core
import Dependencies
import SwiftUI

public struct MainTabView: View {
    let dependencies: Dependencies
    let authCoordinator: NavigationCoordinator<AuthenticationViewState>

    public init(
        dependencies: Dependencies,
        authCoordinator: NavigationCoordinator<AuthenticationViewState>
    ) {
        self.dependencies = dependencies
        self.authCoordinator = authCoordinator
    }

    public var body: some View {
        TabView {
            IdeaListView(
                viewModel: IdeaListViewModel(dependencies: dependencies)
            )
            .tabItem {
                Label("Feed", systemImage: "lightbulb")
            }

            SettingsView(
                viewModel: SettingsViewModel(
                    authentication: dependencies.authentication,
                    pushNotifications: PushNotifications(),
                    coordinator: authCoordinator,
                    analytics: dependencies.analytics
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
