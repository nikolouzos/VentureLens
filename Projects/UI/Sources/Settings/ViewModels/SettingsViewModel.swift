import Core
import Dependencies
import Foundation
import Networking
import SwiftUI
import SwiftUICore

@MainActor
public final class SettingsViewModel: ObservableObject {
    // MARK: - Dependencies

    public lazy var paywallViewModel: PaywallViewModel = .init(dependencies: dependencies)
    public let dependencies: Dependencies
    private let pushNotifications: PushNotificationsProtocol
    let appMetadata: AppMetadata

    // MARK: - Published Properties

    @Published private var pushNotificationStatus: PushNotificationStatus? = .none
    @Published private var coordinator: any NavigationCoordinatorProtocol<AuthenticationViewState>
    @Published var user: User?
    @Published var dataSharingToggle = false
    @Published private(set) var isLoading = false
    @Published var error: Error?
    @Published var showManagementView = false

    var isPremiumActive: Bool {
        user?.subscription == .premium
    }

    var freeUnlockAvailable: Bool {
        guard let lastUnlockTime = user?.lastUnlockTime,
              user?.weeklyUnlocksUsed ?? 0 >= 1
        else {
            return true // No last unlock time or unlocks not used
        }

        let oneWeekAgo = Date().addingTimeInterval(-7 * 24 * 60 * 60)
        return lastUnlockTime < oneWeekAgo
    }

    var nextUnlockDate: Date? {
        guard !freeUnlockAvailable,
              let lastUnlockTime = user?.lastUnlockTime
        else {
            return nil
        }

        return lastUnlockTime.addingTimeInterval(7 * 24 * 60 * 60)
    }

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

    // MARK: - Initialization

    public init(
        isDataSharingEnabled: Bool = UserDefaults.standard.isAnalyticsTrackingEnabled,
        dependencies: Dependencies,
        pushNotifications: PushNotificationsProtocol,
        coordinator: any NavigationCoordinatorProtocol<AuthenticationViewState>,
        appMetadata: AppMetadata = AppMetadata()
    ) {
        dataSharingToggle = isDataSharingEnabled
        self.dependencies = dependencies
        self.pushNotifications = pushNotifications
        self.coordinator = coordinator
        self.appMetadata = appMetadata
    }

    // MARK: - Public Methods

    func handleDataSharingChange(_ isEnabled: Bool) {
        if isEnabled {
            dependencies.analytics.enableTracking(userId: user?.id.uuidString)
        } else {
            dependencies.analytics.disableTracking()
        }
    }

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
                    error = PushNotificationError.permissionDenied
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

    func fetchUser() async {
        let user = await dependencies.authentication.currentUser
        self.user = user
    }

    func updateUserProfile(_ userAttributes: UserAttributes) async throws {
        try await dependencies.authentication.update(userAttributes)
    }

    func logout() {
        isLoading = true
        Task { @MainActor in
            do {
                try await dependencies.authentication.logout()
                dependencies.analytics.reset()

                isLoading = false
                coordinator.reset()
            } catch {
                self.error = error
                isLoading = false
            }
        }
    }

    func deleteAccount() {
        isLoading = true
        Task { @MainActor in
            do {
                try await dependencies.authentication.deleteAccount()
                dependencies.analytics.reset()

                isLoading = false
                coordinator.reset()
            } catch {
                self.error = error
                isLoading = false
            }
        }
    }

    func showSubscriptionManagement() {
        showManagementView = true
    }
}
