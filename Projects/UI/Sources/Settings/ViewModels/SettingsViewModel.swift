import Combine
import Core
import Foundation
import Networking

public class SettingsViewModel: FailableViewModel, ObservableObject {
    let authentication: Authentication
    @Published private var coordinator: NavigationCoordinator<AuthenticationViewState>
    @Published var pushNotificationsEnabled = true
    @Published var dataSharing = false
    @Published var isLoading = false
    @Published public var error: Error?

    var cancellables = Set<AnyCancellable>()

    public init(
        authentication: Authentication,
        coordinator: NavigationCoordinator<AuthenticationViewState>,
        pushNotificationsEnabled: Bool = true,
        dataSharing: Bool = false,
        isLoading: Bool = false,
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    ) {
        self.authentication = authentication
        self.coordinator = coordinator
        self.pushNotificationsEnabled = pushNotificationsEnabled
        self.dataSharing = dataSharing
        self.isLoading = isLoading
        self.cancellables = cancellables
    }

    func updateSettings() {
        isLoading = true
        // Implement update settings logic here
        // Use NetworkManager to make API call
    }

    @MainActor
    func logout() {
        isLoading = true
        Task {
            do {
                try await authentication.logout()
                await MainActor.run {
                    coordinator.reset()
                }
            } catch {
                print(error)
            }
        }
        isLoading = false
    }

    func deleteAccount() {
        // Implement delete account logic here
    }
}
