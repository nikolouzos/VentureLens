import AppResources
import AuthenticationServices
import Core
import SwiftUI

public struct AuthView: View {
    @StateObject private var viewModel: AuthViewModel
    @State private var keyboardIsHidden = true

    public init(viewModel: AuthViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            VStack(spacingSize: .xl) {
                Spacer()
                titleView
                Spacer()
                authenticationButtonViews
                legalLinksView
            }
            .disabled(viewModel.isLoading)
            .padding(.all, .lg)
            .alert(
                "Error",
                isPresented: Binding(
                    get: { viewModel.error != nil },
                    set: { _ in viewModel.error = nil }
                ),
                presenting: viewModel.error
            ) { _ in
                Button("OK", role: .cancel, action: {})
            } message: { error in
                Text(error.localizedDescription)
            }
            .onKeyboardEvent(.willShow) {
                keyboardIsHidden = false
            }
            .onKeyboardEvent(.willHide) {
                keyboardIsHidden = true
            }
            .sheet(isPresented: $viewModel.shouldShowGuestBenefitModal) {
                GuestModeBenefitModalView(
                    onContinueAsGuest: {
                        viewModel.shouldShowGuestBenefitModal = false
                        viewModel.continueAsGuest()
                    },
                    onCreateAccount: {
                        viewModel.shouldShowGuestBenefitModal = false
                    }
                )
            }
        }
    }

    private var titleView: some View {
        AppearTransitionView(
            transition: .opacity.combined(with: .move(edge: .bottom)),
            duration: 0.5,
            delay: 0.5
        ) {
            (Text("Welcome to ")
                .font(.plusJakartaSans(.title, weight: .regular)) +
                Text("VentureLens")
                .foregroundStyle(Color.tint)
                .font(.plusJakartaSans(.title, weight: .bold)))
                .multilineTextAlignment(.center)
        }
    }

    private var authenticationButtonViews: some View {
        VStack(spacingSize: .lg) {
            GroupBox {
                TextField("Email", text: $viewModel.email)
                    .font(.plusJakartaSans(.body, weight: .regular))
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
            }

            Button {
                Task { await viewModel.continueWithOTP() }
            } label: {
                Text("Sign in with OTP")
            }
            .buttonStyle(
                ProminentButtonStyle(
                    isLoading: viewModel.isLoading,
                    fullWidth: true
                )
            )
            .disabled(!viewModel.emailIsValid)

            SignInWithAppleButton(
                onRequest: viewModel.signInWithAppleOnRequest,
                onCompletion: { result in
                    viewModel.signInWithAppleOnCompletion(
                        result: result.map { $0 as AppleAuthorizationProtocol }
                    )
                }
            )
            .frame(heightSize: .composite(.xl, .md))
            .clipShape(RoundedRectangle(cornerSize: .md))

            Text("or")
                .font(.plusJakartaSans(.caption, weight: .medium))
                .foregroundStyle(Color.gray)

            Button {
                viewModel.guestButtonTapped()
            } label: {
                Text("Continue as Guest")
            }
            .buttonStyle(TextButtonStyle())
        }
        .disabled(viewModel.isLoading)
    }

    private var legalLinksView: some View {
        HStack(spacingSize: .md) {
            Link(
                "Terms of Service",
                destination: viewModel.appMetadata.legalURLs.termsOfService
            )
            Link(
                "Privacy Policy",
                destination: viewModel.appMetadata.legalURLs.privacyPolicy
            )
        }
        .buttonStyle(
            TextButtonStyle(
                tintColor: .secondary,
                font: .plusJakartaSans(.subheadline, weight: .medium)
            )
        )
        .padding(.top, .xs)
    }
}

#if DEBUG
    import Core
    import Dependencies

    #Preview {
        AuthView(
            viewModel: AuthViewModel(
                authentication: Dependencies().authentication,
                appMetadata: AppMetadata(),
                coordinator: NavigationCoordinator()
            )
        )
        .tint(AppResourcesAsset.Colors.accentColor.swiftUIColor)
        .environment(\.font, .plusJakartaSans(.body))
    }
#endif
