import AuthenticationServices
import Combine
import Core
import Foundation
import Networking
import SwiftData
import SwiftUI

public class AuthViewModel: ObservableObject {
    // MARK: - Properties

    private let signupDataSource: DataSource<OAuthSignupData>?
    private let authentication: Authentication
    let appMetadata: AppMetadata

    @Published var email = ""
    @Published var isLoading = false
    @Published public var error: Error?
    @Published public var coordinator: any NavigationCoordinatorProtocol<AuthenticationViewState>
    @Published var shouldShowGuestBenefitModal: Bool = false

    var emailIsValid: Bool {
        let emailRegex = /^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
        return email.wholeMatch(of: emailRegex) != nil
    }

    // MARK: - Initializer

    public init(
        authentication: Authentication,
        appMetadata: AppMetadata,
        coordinator: any NavigationCoordinatorProtocol<AuthenticationViewState>,
        signupDataSource: DataSource<OAuthSignupData>? = .init(
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .automatic
            )
        )
    ) {
        self.authentication = authentication
        self.appMetadata = appMetadata
        self.coordinator = coordinator
        self.signupDataSource = signupDataSource
    }

    // MARK: - Apple Sign In

    func signInWithAppleOnRequest(request: AppleIDRequestProtocol) {
        request.requestedScopes = [.email, .fullName]
        isLoading = true
    }

    @MainActor
    func signInWithAppleOnCompletion(result: Result<AppleAuthorizationProtocol, any Error>) {
        do {
            let authorization = try result.throwable()

            guard let credential = authorization.credential as? AppleIDCredentialProtocol,
                  let identityTokenData = credential.identityToken,
                  let identityToken = String(data: identityTokenData, encoding: .utf8)
            else {
                return
            }

            Task {
                let signupData = await constructSignupData(from: credential)
                await signInWithApple(identityToken: identityToken, signupData: signupData)
            }
        } catch {
            self.error = error
        }
        isLoading = false
    }

    // MARK: - OTP Login

    @MainActor
    func continueWithOTP() async {
        isLoading = true
        do {
            try await authentication.authenticate(
                with: .otp(email: email)
            )

            await coordinator.navigate(
                to: authentication.currentUser == nil
                    ? .otp(signupEmail: email)
                    : .loggedIn
            )
        } catch {
            self.error = error
        }

        isLoading = false
    }

    // MARK: - Guest Mode Handling

    @MainActor
    func guestButtonTapped() {
        shouldShowGuestBenefitModal = true
    }

    @MainActor
    func continueAsGuest() {
        isLoading = true
        Task {
            do {
                try await authentication.authenticate(with: .anonymous)
                coordinator.navigate(to: .loggedIn)
            } catch {
                self.error = error
            }
        }
        isLoading = false
    }

    // MARK: - Private Helpers

    private func constructSignupData(
        from credential: AppleIDCredentialProtocol
    ) async -> OAuthSignupData? {
        if let email = credential.email,
           let fullName = credential.fullName
        {
            let signupData = OAuthSignupData(email: email, name: fullName.formatted())
            await signupDataSource?.append(signupData)
            return signupData
        }

        return try? await signupDataSource?.fetch().first
    }

    @MainActor
    private func signInWithApple(
        identityToken: String,
        signupData: OAuthSignupData?
    ) async {
        do {
            try await authentication.authenticate(
                with: .apple(
                    identityToken: identityToken,
                    signupData: signupData
                )
            )
            coordinator.navigate(to: .loggedIn)
        } catch {
            self.error = error
        }
    }
}
