import Combine
import Core
import Foundation
import Networking
import SwiftUICore

@MainActor
public class ProfileViewModel: FailableViewModel, ObservableObject {
    private let updateUserProfile: (_ userAttributes: UserAttributes) async throws -> Void
    private let updateUser: () async -> Void

    @Published private(set) var name: String
    @Published private(set) var email: String
    let subscription: SubscriptionType?
    let authenticationProvider: Provider?
    @Published var emailField: String
    @Published var nameField: String
    @Published private(set) var isLoading = false
    @Published private(set) var isEditing = false
    @Published public var error: Error? = nil

    var isEmailEditable: Bool {
        guard let authenticationProvider else {
            return true
        }
        return !Provider.allCases.contains(authenticationProvider)
    }

    var emailEditingDisclaimer: String {
        isEmailEditable ? "" : "Email cannot be changed for 3rd party login accounts"
    }

    public init(settingsViewModel: SettingsViewModel) {
        name = settingsViewModel.user?.name ?? ""
        email = settingsViewModel.user?.email ?? ""
        subscription = settingsViewModel.user?.subscription
        authenticationProvider = settingsViewModel.user?.provider
        nameField = settingsViewModel.user?.name ?? ""
        emailField = settingsViewModel.user?.email ?? ""
        updateUserProfile = settingsViewModel.updateUserProfile
        updateUser = settingsViewModel.fetchUser
    }

    func startEditing() {
        isEditing = true
    }

    func stopEditing() {
        isEditing = false
    }

    func updateProfile() async {
        isLoading = true
        do {
            try await updateUserProfile(
                UserAttributes(
                    email: emailField,
                    name: nameField
                )
            )
            await updateUser()

            name = nameField
            email = email
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
