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
    @Published var emailField: String
    @Published var nameField: String
    @Published private(set) var isLoading = false
    @Published public var error: Error? = nil

    public init(settingsViewModel: SettingsViewModel) {
        name = settingsViewModel.user?.name ?? ""
        email = settingsViewModel.user?.email ?? ""
        subscription = settingsViewModel.user?.subscription
        nameField = settingsViewModel.user?.name ?? ""
        emailField = settingsViewModel.user?.email ?? ""
        updateUserProfile = settingsViewModel.updateUserProfile
        updateUser = settingsViewModel.fetchUser
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
