import Combine
import Core
import Foundation
import Networking
import SwiftUICore

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
        self.name = settingsViewModel.user?.name ?? ""
        self.email = settingsViewModel.user?.email ?? ""
        self.subscription = settingsViewModel.user?.subscription
        self.nameField = settingsViewModel.user?.name ?? ""
        self.emailField = settingsViewModel.user?.email ?? ""
        self.updateUserProfile = settingsViewModel.updateUserProfile
        self.updateUser = settingsViewModel.fetchUser
    }

    @MainActor
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
