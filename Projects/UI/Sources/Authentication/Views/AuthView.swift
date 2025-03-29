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
                            (Text("VentureLens")

                                .foregroundStyle(Color.tint))
                    )
                    .font(.plusJakartaSans(.title, weight: .bold))
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
                        .font(.plusJakartaSans(.caption, weight: .medium))
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
                    image: AppResourcesAsset.Assets.onboardingList.swiftUIImage,
                    description: "Every morning, we serve you with fresh, curated business opportunities. Our smart algorithms do the heavy lifting for you."
                ),
                .init(
                    image: AppResourcesAsset.Assets.onboardingOverview.swiftUIImage,
                    description: "Tap into any idea to explore a comprehensive report. Each report is packed with insights to help you make informed decisions."
                ),
                .init(
                    image: AppResourcesAsset.Assets.onboardingFinancial.swiftUIImage,
                    description: "Not sure if an idea is worth pursuing? VentureLens all the data & analysis to help you validate opportunities quickly and confidently."
                ),
                .init(
                    image: AppResourcesAsset.Assets.onboardingFilters.swiftUIImage,
                    description: "Make VentureLens truly yours! Use the filtering options to customize your feed and find opportunities that align with your goals."
                ),
                .init(
                    image: AppResourcesAsset.Assets.onboardingRoadmap.swiftUIImage,
                    description: "Use our roadmap feature to break it down into actionable steps - get MVP ready in an instant!"
                ),
            ])
        }
    }
}

#if DEBUG
    import Core
    import Dependencies

    #Preview {
        AuthView(
            viewModel: AuthViewModel(
                authentication: Dependencies().authentication,
                coordinator: NavigationCoordinator()
            )
        )
        .tint(AppResourcesAsset.Colors.accentColor.swiftUIColor)
        .environment(\.font, .plusJakartaSans(.body))
    }
#endif
