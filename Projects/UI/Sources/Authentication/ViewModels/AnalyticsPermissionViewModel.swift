import Core
import Dependencies
import Foundation
import Networking
import SwiftUI

@MainActor
public final class AnalyticsPermissionViewModel: ObservableObject {
    private let analytics: Analytics
    private let authentication: Authentication
    @Published private var coordinator: any NavigationCoordinatorProtocol<AuthenticationViewState>
    @Published var isLoading: Bool = false

    public init(
        analytics: Analytics,
        authentication: Authentication,
        coordinator: any NavigationCoordinatorProtocol<AuthenticationViewState>
    ) {
        self.analytics = analytics
        self.authentication = authentication
        self.coordinator = coordinator
    }

    public func allowTracking() async {
        isLoading = true

        // Mark permission as shown
        UserDefaults.standard.hasShownAnalyticsPermission = true

        // Get user ID if available and enable tracking
        let uid = await authentication.currentUser?.id.uuidString
        analytics.enableTracking(userId: uid)

        // Navigate to the main app
        coordinator.navigate(to: .loggedIn)

        isLoading = false
    }

    public func denyTracking() async {
        isLoading = true

        // Mark permission as shown
        UserDefaults.standard.hasShownAnalyticsPermission = true

        // Disable tracking
        analytics.disableTracking()

        // Navigate to the main app
        coordinator.navigate(to: .loggedIn)

        isLoading = false
    }
}
