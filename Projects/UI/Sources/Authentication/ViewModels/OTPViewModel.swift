import Core
import Foundation
import Networking

public class OTPViewModel: FailableViewModel, ObservableObject {
    private let authentication: Authentication
    let signupEmail: String
    @Published var coordinator: NavigationCoordinator<AuthenticationViewState>
    @Published var otp: String = ""
    @Published public var isLoading: Bool = false
    @Published public var error: Error?

    public init(
        authentication: Authentication,
        coordinator: NavigationCoordinator<AuthenticationViewState>,
        signupEmail: String
    ) {
        self.authentication = authentication
        self.coordinator = coordinator
        self.signupEmail = signupEmail
    }

    @MainActor
    public func verifyOTP(_ otp: String) {
        guard otp.count == 6 else {
            return
        }
        isLoading = true

        Task {
            do {
                try await authentication.verifyOTP(email: signupEmail, token: otp)
                await MainActor.run {
                    coordinator.reset()
                }
            } catch {
                print(error)
                await MainActor.run {
                    self.error = error
                }
            }
        }

        isLoading = false
    }
}
