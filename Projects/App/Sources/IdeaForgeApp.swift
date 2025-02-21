import AppResources
import SwiftUI

@main
struct VentureLensApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
                .tint(
                    AppResourcesAsset.Colors.accentColor.swiftUIColor
                )
        }
    }
}

#Preview {
    AppView()
}
