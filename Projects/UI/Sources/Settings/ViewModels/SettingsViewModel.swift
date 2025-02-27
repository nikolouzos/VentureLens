import Combine
import Core
import Foundation
import Networking
import SwiftUICore

public class SettingsViewModel: FailableViewModel, ObservableObject {
    private let authentication: Authentication
    private let pushNotifications: PushNotificationsProtocol
    @Published private var pushNotificationStatus: PushNotificationStatus? = .none
    @Published private var coordinator: NavigationCoordinator<AuthenticationViewState>
    @Published var user: User?
    @Published var dataSharingToggle = false
    @Published private(set) var isLoading = false
    @Published public var error: Error?
    
    var pushNotificationsToggle: Binding<Bool> {
        Binding(
            get: {
                if let status = self.pushNotificationStatus {
                    switch status {
                    case .authorized, .provisional, .ephemeral:
                        return true
                    case .denied, .notDetermined:
                        return false
                    }
                }
                return false
            },
            set: { newValue in
                Task {
                    await self.handlePushNotificationsUpdated(newValue)
                }
            }
        )
    }

    public init(
        authentication: Authentication,
        pushNotifications: PushNotificationsProtocol = PushNotifications(),
        coordinator: NavigationCoordinator<AuthenticationViewState>,
        dataSharing: Bool = false
    ) {
        self.authentication = authentication
        self.pushNotifications = pushNotifications
        self.coordinator = coordinator
        self.dataSharingToggle = dataSharingToggle
    }
    
    @MainActor
    func getSettings() async {
        isLoading = true
        
        do {
            pushNotificationStatus = try await pushNotifications.getNotificationStatus()
            await fetchUser()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    @MainActor
    private func handlePushNotificationsUpdated(_ newStatus: Bool) async {
        let canRequestPushNotifications = pushNotificationStatus == .none ||
            pushNotificationStatus == .notDetermined ||
        pushNotificationStatus == .denied
        
        if newStatus {
            guard canRequestPushNotifications else {
                return
            }
            
            do {
                let permissionGranted = try await pushNotifications.requestPermission()
                if permissionGranted {
                    pushNotificationStatus = try await pushNotifications.getNotificationStatus()
                } else {
                    self.error = PushNotificationError.permissionDenied
                }
            } catch {
                self.error = error
            }
            
            return
        }
        
        do {
            try await pushNotifications.openNotificationSettings()
        } catch {
            self.error = error
        }
    }
    
    @MainActor
    func fetchUser() async {
        user = await authentication.currentUser
    }
    
    func updateUserProfile(_ userAttributes: UserAttributes) async throws {
        try await authentication.update(userAttributes)
    }

    @MainActor
    func logout() {
        isLoading = true
        Task { @MainActor in
            do {
                try await authentication.logout()
                isLoading = false
                coordinator.reset()
            } catch {
                self.error = error
                isLoading = false
            }
        }
    }

    @MainActor
    func deleteAccount() {
        isLoading = true
        Task { @MainActor in
            do {
                try await authentication.deleteAccount()
                isLoading = false
                coordinator.reset()
            } catch {
                self.error = error
                isLoading = false
            }
        }
    }
}
