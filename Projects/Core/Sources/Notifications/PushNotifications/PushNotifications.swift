import Foundation
import UserNotifications
import UIKit

public final class PushNotifications: PushNotificationsProtocol {
    private let notificationCenter: UNUserNotificationCenter
    private let urlOpener: URLOpener
    
    public init(
        notificationCenter: UNUserNotificationCenter = .current(),
        urlOpener: URLOpener = UIApplication.shared
    ) {
        self.notificationCenter = notificationCenter
        self.urlOpener = urlOpener
    }
    
    public func requestPermission(
        options: UNAuthorizationOptions = [.alert, .sound, .badge]
    ) async throws -> Bool {
        do {
            return try await notificationCenter.requestAuthorization(options: options)
        } catch {
            throw PushNotificationError.unknown(error)
        }
    }
    
    public func getNotificationStatus() async throws -> PushNotificationStatus {
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
    
    public func openNotificationSettings() async throws -> Bool {
        guard let settingsUrl = URL(string: "app-settings:notification"),
              urlOpener.canOpenURL(settingsUrl) else {
            throw PushNotificationError.settingsURLNotAvailable
        }
        return await urlOpener.open(settingsUrl)
    }
}
