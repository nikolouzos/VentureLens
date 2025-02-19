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
                viewModel: IdeaListViewModel(
                    apiClient: dependencies.apiClient,
                    authentication: dependencies.authentication
                )
            )
            .tabItem {
                Label("Feed", systemImage: "lightbulb")
            }

            SettingsView(
                viewModel: SettingsViewModel(
                    authentication: dependencies.authentication,
                    coordinator: authCoordinator
                )
            )
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}
