import Core
import Dependencies
import Foundation
import Networking
import SwiftUICore

@MainActor
public final class SettingsViewModel: ObservableObject {
    private let authentication: Authentication
    private let pushNotifications: PushNotificationsProtocol
    private let analytics: Analytics
    @Published private var pushNotificationStatus: PushNotificationStatus? = .none
    @Published private var coordinator: NavigationCoordinator<AuthenticationViewState>
    @Published var user: User?
    @Published var dataSharingToggle = false
    @Published private(set) var isLoading = false
    @Published public var error: Error?

    private let appVersion: AppVersion

    var versionString: String {
        "App Version: \(appVersion.versionString)"
    }

    let legalURLs: (termsOfService: URL, privacyPolicy: URL) = (
        termsOfService: URL(string: "https://venturelens.app/terms")!,
        privacyPolicy: URL(string: "https://venturelens.app/privacy")!
    )

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

    public init(
        isDataSharingEnabled: Bool = UserDefaults.standard.isAnalyticsTrackingEnabled,
        authentication: Authentication,
        pushNotifications: PushNotificationsProtocol,
        coordinator: NavigationCoordinator<AuthenticationViewState>,
        analytics: Analytics,
        appVersion: AppVersion = AppVersion()
    ) {
        dataSharingToggle = isDataSharingEnabled
        self.authentication = authentication
        self.pushNotifications = pushNotifications
        self.coordinator = coordinator
        self.analytics = analytics
        self.appVersion = appVersion
    }

    func handleDataSharingChange(_ isEnabled: Bool) {
        if isEnabled {
            analytics.enableTracking(userId: user?.id.uuidString)
        } else {
            analytics.disableTracking()
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
        user = await authentication.currentUser
    }

    func updateUserProfile(_ userAttributes: UserAttributes) async throws {
        try await authentication.update(userAttributes)
    }

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
