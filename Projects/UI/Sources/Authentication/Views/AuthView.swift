import AppResources
import AuthenticationServices
import SwiftUI

public struct AuthView: View {
    @StateObject private var viewModel: AuthViewModel
    @State private var startSignupFlow: Bool = false
    @State private var keyboardIsShowing = false

    public init(viewModel: AuthViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            VStack(spacingSize: .lg) {
                if !keyboardIsShowing {
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
                            description: "Tailor IdeaForge to your interests. Set investment tiers, specific industries and more."
                        ),
                    ])
                }
                Spacer()

                GroupBox {
                    TextField("Email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }

                VStack(alignment: .center, spacingSize: .lg) {
                    Button {
                        Task {
                            await viewModel.login()
                        }
                    } label: {
                        Text(
                            "Sign in with OTP"
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                    }
                    .background(
                        RoundedRectangle(cornerSize: .sm)
                            .foregroundStyle(Color.themeSecondary)
                    )
                    .disabled(viewModel.isLoading)

                    Text("or")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.gray)

                    SignInWithAppleButton(
                        onRequest: viewModel.signInWithAppleOnRequest,
                        onCompletion: viewModel.signInWithAppleOnCompletion
                    )
                    .frame(height: 44)
                    .disabled(viewModel.isLoading)
                }
            }
            .padding(.all, .lg)
            .navigationTitle("Welcome to IdeaForge!")
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
                keyboardIsShowing = true
            }
            .onKeyboardEvent(.willHide) {
                keyboardIsShowing = false
            }
        }
    }
}

#if DEBUG
    import Core
    import Networking

    #Preview {
        AuthView(
            viewModel: AuthViewModel(
                authentication: AuthenticationMock(),
                coordinator: NavigationCoordinator()
            )
        )
        .tint(Color.accentColor)
    }
#endif
