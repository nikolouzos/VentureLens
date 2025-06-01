import Foundation
import UIKit
import UserNotifications

@MainActor
public final class PushNotifications: PushNotificationsProtocol {
    private let notificationCenter: UNUserNotificationCenter
    private let urlOpener: URLOpener

    public init(
        notificationCenter: UNUserNotificationCenter = .current(),
        urlOpener: URLOpener? = nil
    ) {
        self.notificationCenter = notificationCenter
        self.urlOpener = urlOpener ?? UIApplication.shared
    }

    public func requestPermission(
        options _: UNAuthorizationOptions = [.alert, .sound, .badge]
    ) async throws -> Bool {
        do {
            let authorizationTask = Task { [notificationCenter] in
                return try await notificationCenter.requestAuthorization()
            }
            return try await authorizationTask.value
        } catch {
            throw PushNotificationError.unknown(error)
        }
    }

    public func getNotificationStatus() async throws -> PushNotificationStatus {
        let statusTask = Task { [notificationCenter] () async -> PushNotificationStatus in
            let settings = await notificationCenter.notificationSettings()

            switch settings.authorizationStatus {
            case .authorized:
                return .authorized

            case .denied:
                return .denied

            case .notDetermined:
                return .notDetermined

            case .provisional:
                return .provisional

            case .ephemeral:
                return .ephemeral

            @unknown default:
                return .notDetermined
            }
        }

        return await statusTask.value
    }

    public func openNotificationSettings() async throws -> Bool {
        guard let settingsUrl = URL(string: "app-settings:notification"),
              urlOpener.canOpenURL(settingsUrl)
        else {
            throw PushNotificationError.settingsURLNotAvailable
        }
        return await urlOpener.open(settingsUrl)
    }
}
