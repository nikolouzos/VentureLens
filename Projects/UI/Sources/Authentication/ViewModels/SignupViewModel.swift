import Combine
import Core
import Foundation
import Networking

@MainActor
public final class SignupViewModel: ObservableObject {
    private let authentication: Authentication
    @Published var coordinator: NavigationCoordinator<AuthenticationViewState>
    @Published var name: String = ""
    @Published var isLoading: Bool = false
    @Published var error: Error?

    public init(
        authentication: Authentication,
        coordinator: NavigationCoordinator<AuthenticationViewState>
    ) {
        self.authentication = authentication
        self.coordinator = coordinator
    }

    public func continueSignup() async {
        guard !name.isEmpty else { return }

        isLoading = true

        do {
            // Create user attributes with the name
            let userAttributes = UserAttributes(name: name)

            // Update the user profile with the name
            try await authentication.update(userAttributes)

            // Navigate to the logged in state after successful update
            coordinator.navigate(to: .loggedIn)
        } catch {
            self.error = error
            isLoading = false
        }
    }
}
