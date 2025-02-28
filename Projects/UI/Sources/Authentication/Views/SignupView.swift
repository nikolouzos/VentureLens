import SwiftUI
import Core
import Networking

public struct SignupView: View {
    @StateObject private var viewModel: SignupViewModel
    @FocusState private var isNameFieldFocused: Bool
    @State private var keyboardIsHidden = true
    
    public init(viewModel: SignupViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
                    headerView
                }
                
                Spacer()
                
                nameInputSection
                
                continueButton
                    .padding(.vertical, .md)
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
        VStack(spacingSize: .md) {
            Text("Welcome to")
                .font(.title)
            
            Text("VentureLens")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color.tint)
            
            Text("Let's get started by setting up your profile")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.secondary)
                .padding(.top, .sm)
        }
    }
    
    private var nameInputSection: some View {
        VStack(alignment: .leading, spacingSize: .sm) {
            Text("What's your name?")
                .font(.headline)
                .foregroundStyle(Color.primary)
            
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
            HStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(.white)
                } else {
                    Text("Continue")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(
                RoundedRectangle(cornerSize: .sm)
                    .foregroundStyle(viewModel.name.isEmpty ? Color.gray.opacity(0.3) : Color.themeSecondary)
            )
            .foregroundColor(.white)
        }
        .disabled(viewModel.name.isEmpty)
    }
}

#if DEBUG
    #Preview {
        SignupView(
            viewModel: SignupViewModel(
                authentication: MockAuthentication(),
                coordinator: NavigationCoordinator<AuthenticationViewState>()
            )
        )
    }
#endif 
