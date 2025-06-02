import AppResources
import Core
import SwiftUI

public struct SignupView: View {
    @StateObject private var viewModel: SignupViewModel
    @FocusState private var isNameFieldFocused: Bool
    @State private var keyboardIsHidden = true

    public init(viewModel: SignupViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            VStack(spacingSize: .md) {
                AppearTransitionView(
                    transition: .opacity
                        .combined(
                            with: .move(edge: .bottom)
                        ),
                    duration: 0.5,
                    delay: 0.5
                ) {
                    headerView
                }

                Spacer()

                nameInputSection

                continueButton
                    .padding(.bottom, .xl)
            }
            .padding(.horizontal, .lg)
            .padding(.top, .xl)
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.large)
            .disabled(viewModel.isLoading)
            .alert(isPresented: Binding(
                get: { viewModel.error != nil },
                set: { if !$0 { viewModel.error = nil } }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.error?.localizedDescription ?? "An unknown error occurred"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onKeyboardEvent(.willShow) {
                keyboardIsHidden = false
            }
            .onKeyboardEvent(.willHide) {
                keyboardIsHidden = true
            }
        }
    }

    private var headerView: some View {
        Text("Let's get started setting up your profile")
            .font(
                .plusJakartaSans(.title3, weight: .bold)
            )
            .multilineTextAlignment(.center)
    }

    private var nameInputSection: some View {
        VStack(alignment: .leading, spacingSize: .sm) {
            Text("What's your name?")
                .font(.plusJakartaSans(.headline))
                .foregroundStyle(Color.primary)
                .padding(.leading, .md)

            GroupBox {
                TextField("Enter your name", text: $viewModel.name)
                    .autocapitalization(.words)
                    .focused($isNameFieldFocused)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isNameFieldFocused = true
                        }
                    }
            }
            .padding(.bottom, .sm)
        }
    }

    private var continueButton: some View {
        Button {
            Task {
                await viewModel.continueSignup()
            }
        } label: {
            Text("Continue")
        }
        .buttonStyle(
            ProminentButtonStyle(
                isLoading: viewModel.isLoading,
                fullWidth: true,
                backgroundColor: .themeSecondary
            )
        )
        .disabled(viewModel.name.isEmpty)
    }
}

#if DEBUG
    import Dependencies

    #Preview {
        SignupView(
            viewModel: SignupViewModel(
                authentication: Dependencies().authentication,
                coordinator: NavigationCoordinator()
            )
        )
    }
#endif
