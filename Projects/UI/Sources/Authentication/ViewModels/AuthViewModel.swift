import AuthenticationServices
import Combine
import Core
import Foundation
import Networking
import SwiftData
import SwiftUI

public class AuthViewModel: FailableViewModel, ObservableObject {
    private let authentication: Authentication
    @Published var email = ""
    @Published var isLoading = false
    @Published public var error: Error?
    @Published public var coordinator: NavigationCoordinator<AuthenticationViewState>
    private let signupDataSource: DataSource<OAuthSignupData>?

    public init(
        authentication: Authentication,
        coordinator: NavigationCoordinator<AuthenticationViewState>,
        signupDataSource: DataSource<OAuthSignupData>? = .init(
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .automatic
            )
        )
    ) {
        self.authentication = authentication
        self.coordinator = coordinator
        self.signupDataSource = signupDataSource
    }

    func signInWithAppleOnRequest(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.email, .fullName]
        isLoading = true
    }

    @MainActor
    func signInWithAppleOnCompletion(result: Result<ASAuthorization, any Error>) {
        do {
            let authorization = try result.throwable()
            
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                  let identityTokenData = credential.identityToken,
                  let identityToken = String(data: identityTokenData, encoding: .utf8) else {
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
    
    private func constructSignupData(
        from credential: ASAuthorizationAppleIDCredential
    ) async -> OAuthSignupData? {
        if let email = credential.email,
           let fullName = credential.fullName {
            let signupData = OAuthSignupData(email: email, name: fullName.formatted())
            await signupDataSource?.append(signupData)
            return signupData
        }
        
        return try? await signupDataSource?.fetch().first
    }

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
            await MainActor.run {
                coordinator.navigate(to: .loggedIn)
            }
        } catch {
            await MainActor.run {
                self.error = error
            }
        }
    }
}
