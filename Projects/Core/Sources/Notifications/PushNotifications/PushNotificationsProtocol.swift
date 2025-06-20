import Foundation
import UserNotifications

public enum PushNotificationStatus: Sendable {
    case authorized
    case denied
    case notDetermined
    case provisional
    case ephemeral
}

public enum PushNotificationError: LocalizedError {
    case notificationSettingsUnavailable
    case permissionDenied
    case unknown(Error)
    case settingsURLNotAvailable

    public var errorDescription: String? {
        switch self {
        case .notificationSettingsUnavailable:
            "Unable to fetch notification settings"

        case .permissionDenied:
            "Push notification permission was denied"

        case .settingsURLNotAvailable:
            "Could not open Settings app"

        case let .unknown(error):
            error.localizedDescription
        }
    }
}

@MainActor
public protocol PushNotificationsProtocol: AnyObject {
    init(
        notificationCenter: UNUserNotificationCenter,
        urlOpener: URLOpener?
    )

    /// Request permission to send push notifications
    /// - Parameter options: The types of notifications to request. Defaults to [.alert, .sound, .badge]
    /// - Returns: A boolean indicating if permission was granted
    func requestPermission(
        options: UNAuthorizationOptions
    ) async throws -> Bool

    /// Get the current push notification authorization status
    /// - Returns: The current PushNotificationStatus
    func getNotificationStatus() async throws -> PushNotificationStatus

    /// Opens the Settings app to allow the user to modify notification permissions
    /// - Note: This will take the user out of your app and into the Settings app
    /// - Throws: PushNotificationError.settingsURLNotAvailable if unable to open Settings
    /// - Returns: A boolean indicating if the Settings app was opened
    @discardableResult
    func openNotificationSettings() async throws -> Bool
}

public extension PushNotificationsProtocol {
    func requestPermission(options: UNAuthorizationOptions = [.alert, .sound, .badge]) async throws -> Bool {
        try await requestPermission(options: options)
    }
}
