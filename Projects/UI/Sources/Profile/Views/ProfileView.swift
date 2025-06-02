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
                emailChangeInfo
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

    @ViewBuilder
    private var emailChangeInfo: some View {
        if !viewModel.isEditing, viewModel.didChangeEmailAddress {
            HStack(alignment: .center, spacingSize: .md) {
                Image(systemName: "envelope.badge.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(widthSize: .xl)

                Text("Your email address has been changed. Please check your emails to confirm the change.")
                    .font(.plusJakartaSans(.subheadline, weight: .medium))
            }
            .listRowBackground(
                Color.themeSecondary.opacity(0.2)
            )
        }
    }

    private var buttons: some View {
        Section {
            if viewModel.isEditing {
                Button("Cancel") {
                    viewModel.stopEditing(isCancelled: true)
                }
                .buttonStyle(TextButtonStyle(tintColor: .themePrimary))

                Button("Save") {
                    Task {
                        await viewModel.updateProfile()
                    }
                }
                .buttonStyle(TextButtonStyle())
            } else {
                Button("Edit Profile", action: viewModel.startEditing)
                    .buttonStyle(TextButtonStyle())
            }
        }
    }
}

#if DEBUG
    import Core
    import Dependencies

    #Preview {
        ProfileView(
            viewModel: ProfileViewModel(
                settingsViewModel: SettingsViewModel(
                    dependencies: Dependencies(),
                    pushNotifications: PushNotifications(),
                    coordinator: NavigationCoordinator()
                )
            )
        )
    }
#endif
