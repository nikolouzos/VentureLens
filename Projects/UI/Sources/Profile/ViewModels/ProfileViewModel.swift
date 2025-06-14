import Combine
import Foundation
import Networking
import SwiftUICore

@MainActor
public class ProfileViewModel: ObservableObject {
    private let updateUserProfile: (_ userAttributes: UserAttributes) async throws -> Void

    @Published private(set) var name: String
    @Published private(set) var email: String
    let subscription: SubscriptionType?
    let authenticationProvider: Provider?
    @Published var emailField: String
    @Published var nameField: String
    @Published private(set) var isLoading = false
    @Published private(set) var isEditing = false
    @Published private(set) var didChangeEmailAddress = false
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
    }

    func startEditing() {
        isEditing = true
    }

    func stopEditing(isCancelled: Bool) {
        isEditing = false
        if isCancelled {
            resetFields()
        }
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

            if email != emailField {
                didChangeEmailAddress = true
            }

            email = emailField
            name = nameField
        } catch {
            self.error = error
            resetFields()
        }

        stopEditing(isCancelled: false)
        isLoading = false
    }

    private func resetFields() {
        emailField = email
        nameField = name
    }
}
