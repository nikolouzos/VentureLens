import SwiftUI

public struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel

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
        }
    }

    private var userInfo: some View {
        Section {
            if viewModel.isEditing {
                TextField("Name", text: $viewModel.nameField)

                if viewModel.isEmailEditable {
                    TextField("Email", text: $viewModel.emailField)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                } else {
                    HStack {
                        Image(systemName: "lock.fill")
                            .help(viewModel.emailEditingDisclaimer)
                        Spacer()
                        Text(viewModel.emailField)
                    }
                    .foregroundStyle(Color.secondary)
                }
            } else {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(viewModel.nameField)
                        .foregroundStyle(Color.secondary)
                        .lineLimit(1)
                }

                HStack {
                    Text("Email")
                    Spacer()
                    Text(viewModel.emailField)
                        .foregroundStyle(Color.secondary)
                        .lineLimit(1)
                }
            }
        } footer: {
            emailEditingDisclaimer
        }
    }

    @ViewBuilder
    private var emailEditingDisclaimer: some View {
        if !viewModel.isEmailEditable {
            Text("Note: \(viewModel.emailEditingDisclaimer)")
                .font(.plusJakartaSans(.subheadline, weight: .medium))
                .multilineTextAlignment(.center)
                .padding(.top, .md)
        }
    }

    private var buttons: some View {
        Section {
            if viewModel.isEditing {
                Button("Cancel", action: viewModel.stopEditing)
                    .foregroundStyle(Color.red)
                Button("Save") {
                    Task {
                        await viewModel.updateProfile()
                    }
                    viewModel.stopEditing()
                }
            } else {
                Button("Edit Profile", action: viewModel.startEditing)
            }
        }
    }
}

#if DEBUG
    import Core
    import Dependencies
    import Networking

    #Preview {
        ProfileView(
            viewModel: ProfileViewModel(
                settingsViewModel: SettingsViewModel(
                    authentication: MockAuthentication(),
                    pushNotifications: PushNotifications(),
                    coordinator: NavigationCoordinator(),
                    analytics: Dependencies().analytics
                )
            )
        )
    }
#endif
