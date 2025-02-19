import Combine
import Core
import Foundation
import Networking

public class ProfileViewModel: FailableViewModel, ObservableObject {
    private let authentication: Authentication
    @Published var user: Networking.User? = nil
    @Published private var isLoading = false
    @Published public var error: Error? = nil

    public init(authentication: Authentication) {
        self.authentication = authentication
    }

    @MainActor
    func fetchUserProfile() async {
        isLoading = true
        user = await authentication.currentUser
        isLoading = false
    }

    @MainActor
    func updateProfile(name: String, email: String) async {
        isLoading = true
        do {
            try await authentication.update(
                UserAttributes(
                    email: email,
                    name: name
                )
            )
            await fetchUserProfile()
        } catch {
            self.error = error
        }
    }
}
