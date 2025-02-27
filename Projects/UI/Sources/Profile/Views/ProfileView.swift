import SwiftUI

public struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @State private var isEditing = false

    public init(viewModel: ProfileViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            Form {
                userInfo
                buttons
            }
            .navigationTitle("Profile")
            .alert(
                "Error updating profile",
                isPresented: $viewModel.hasError,
                presenting: viewModel.error
            ) { _ in
                Button("OK", role: .cancel, action: {})
            } message: { error in
                Text(error.localizedDescription)
            }
        }
    }
    
    private var userInfo: some View {
        Section {
            if isEditing {
                TextField("Name", text: $viewModel.nameField)
                TextField("Email", text: $viewModel.emailField)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
            } else {
                Text("Name: \(viewModel.name)")
                Text("Email: \(viewModel.email)")
                Text("Subscription: \(viewModel.subscription?.rawValue.capitalized ?? "")")
            }
        }
    }
    
    private var buttons: some View {
        Section {
            if isEditing {
                Button("Cancel") {
                    isEditing = false
                }
                .foregroundStyle(Color.red)
                Button("Save") {
                    Task {
                        await viewModel.updateProfile()
                    }
                    isEditing = false
                }
            } else {
                Button("Edit Profile") {
                    isEditing = true
                }
            }
        }
    }
}

#if DEBUG
    import Core
    import Networking

    #Preview {
        ProfileView(
            viewModel: ProfileViewModel(
                settingsViewModel: SettingsViewModel(
                    authentication: MockAuthentication(),
                    coordinator: NavigationCoordinator()
                    
                )
            )
        )
    }
#endif
