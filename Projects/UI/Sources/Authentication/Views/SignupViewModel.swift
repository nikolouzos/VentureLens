import Combine
import Core
import Foundation
import Networking

@MainActor
public final class SignupViewModel: ObservableObject {
    private let authentication: AuthClientProtocol
    @Published var coordinator: NavigationCoordinator<AuthenticationViewState>
    @Published var otp: String = ""
    @Published var isLoading: Bool = false
    let signupEmail: String

    public init(
        authentication: AuthClientProtocol,
        coordinator: NavigationCoordinator<AuthenticationViewState>,
        signupEmail: String
    ) {
        self.authentication = authentication
        self.coordinator = coordinator
        self.signupEmail = signupEmail
    }
}
