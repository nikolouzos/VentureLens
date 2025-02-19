import SwiftUI

public struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @State private var isEditing = false
    @State private var name = ""
    @State private var email = ""

    public init(
        viewModel: ProfileViewModel
    ) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            Form {
                Section {
                    if let user = viewModel.user {
                        if isEditing {
                            TextField("Name", text: $name)
                            TextField("Email", text: $email)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                        } else {
                            Text("Name: \(user.name ?? "")")
                            Text("Email: \(user.email ?? "")")
                            Text("Subscription: \(user.subscription ?? "")")
                        }
                    } else {
                        Text("Loading profile...")
                    }
                }

                Section {
                    if isEditing {
                        Button("Save") {
                            Task {
                                await viewModel.updateProfile(name: name, email: email)
                            }
                            isEditing = false
                        }
                    } else {
                        Button("Edit Profile") {
                            name = viewModel.user?.name ?? ""
                            email = viewModel.user?.email ?? ""
                            isEditing = true
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .task {
                await viewModel.fetchUserProfile()
            }
            .alert(
                "Error",
                isPresented: $viewModel.hasError,
                presenting: viewModel.error
            ) { error in
                Text(error.localizedDescription)
            }
        }
    }
}

#if DEBUG
    import Networking

    #Preview {
        ProfileView(
            viewModel: ProfileViewModel(
                authentication: AuthenticationMock()
            )
        )
    }
#endif
