import AppResources
import SwiftUI

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
                .tint(Color.tint)
                .environment(\.font, .plusJakartaSans(.body))
        }
    }
}
