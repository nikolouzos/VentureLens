import AuthenticationServices
import Combine
import Core
import Foundation
import Networking
import SwiftUI

public class AuthViewModel: FailableViewModel, ObservableObject {
    private let authentication: Authentication
    @Published var email = ""
    @Published var isLoading = false
    @Published public var error: Error?
    @Published public var coordinator: NavigationCoordinator<AuthenticationViewState>

    public init(
        authentication: Authentication,
        coordinator: NavigationCoordinator<AuthenticationViewState>
    ) {
        self.authentication = authentication
        self.coordinator = coordinator
    }

    func signInWithAppleOnRequest(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.email, .fullName]
    }

    func signInWithAppleOnCompletion(result: Result<ASAuthorization, any Error>) {
        switch result {
        case let .success(authorization):
            print("Apple Sign In Successful: \(authorization)")

        case let .failure(error):
            print("Apple Sign In Failed: \(error)")
        }
    }

    @MainActor
    func login() async {
        do {
            try await authentication.authenticate(
                with: .otp(email: email)
            )

            isLoading = false
            coordinator.navigate(
                to: await authentication.currentUser == nil
                    ? .otp(signupEmail: email)
                    : .loggedIn
            )
        } catch {
            self.error = error
        }
    }

    func signInWithApple() {
        // Implement Apple Sign In
    }
}
