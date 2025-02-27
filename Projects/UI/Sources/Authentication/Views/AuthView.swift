import AppResources
import AuthenticationServices
import SwiftUI

public struct AuthView: View {
    @StateObject private var viewModel: AuthViewModel
    @State private var keyboardIsHidden = true

    public init(viewModel: AuthViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            VStack(spacingSize: .lg) {
                AppearTransitionView(
                    transition: .opacity.combined(
                        with: .move(edge: .bottom)
                    ),
                    duration: 0.5,
                    delay: 0.5
                ) {
                    (
                        Text("Welcome to ") +
                        Text("VentureLens")
                            .fontWeight(.bold)
                            .foregroundStyle(Color.tint)
                    )
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                }
                
                onboardingTutorialView
                Spacer()

                GroupBox {
                    TextField("Email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }

                VStack(alignment: .center, spacingSize: .lg) {
                    Text("Sign in with OTP")
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        RoundedRectangle(cornerSize: .sm)
                            .foregroundStyle(Color.themeSecondary)
                    )
                    .onTapGesture {
                        Task {
                            await viewModel.login()
                        }
                    }

                    Text("or")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.gray)

                    SignInWithAppleButton(
                        onRequest: viewModel.signInWithAppleOnRequest,
                        onCompletion: viewModel.signInWithAppleOnCompletion
                    )
                    .frame(height: 44)
                }
            }
            .disabled(viewModel.isLoading)
            .padding(.all, .lg)
            .alert(
                "Error",
                isPresented: $viewModel.hasError,
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
        }
    }
    
    private var onboardingTutorialView: some View {
        AppearTransitionView(
            if: $keyboardIsHidden,
            transition: .opacity.combined(with: .scale),
            duration: 0.5,
            delay: 0.5
        ) {
            StepTutorialView(steps: [
                .init(
                    image: Image(systemName: "eraser.fill"),
                    description: "Start your day with unique AI-curated business opportunities"
                ),
                .init(
                    image: Image(systemName: "text.document"),
                    description: "Explore in-depth opportunity reports for every idea."
                ),
                .init(
                    image: Image(systemName: "text.below.photo"),
                    description: "Validate ideas with financial snapshots and competitor benchmarks"
                ),
                .init(
                    image: Image(systemName: "line.3.horizontal.decrease.circle.fill"),
                    description: "Tailor VentureLens to your interests. Set investment tiers, specific industries and more."
                ),
            ])
        }
    }
}

#if DEBUG
    import Core
    import Networking

    #Preview {
        AuthView(
            viewModel: AuthViewModel(
                authentication: MockAuthentication(),
                coordinator: NavigationCoordinator()
            )
        )
        .tint(AppResourcesAsset.Colors.accentColor.swiftUIColor)
    }
#endif
