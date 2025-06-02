import AppResources
import Core
import SwiftUI

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                authCoordinator: NavigationCoordinator()
            )
            .tint(Color.tint)
            .environment(\.font, .plusJakartaSans(.body))
        }
    }
}
