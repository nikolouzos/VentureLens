import Foundation

public extension UserDefaults {
    enum Keys {
        static let hasShownAnalyticsPermission = "hasShownAnalyticsPermission"
        static let isAnalyticsTrackingEnabled = "isAnalyticsTrackingEnabled"
    }

    /// Checks if analytics permission dialog has been shown to the user
    var hasShownAnalyticsPermission: Bool {
        get {
            bool(forKey: Keys.hasShownAnalyticsPermission)
        }
        set {
            set(newValue, forKey: Keys.hasShownAnalyticsPermission)
        }
    }

    /// Gets or sets whether analytics tracking is enabled
    var isAnalyticsTrackingEnabled: Bool {
        get {
            bool(forKey: Keys.isAnalyticsTrackingEnabled)
        }
        set {
            set(newValue, forKey: Keys.isAnalyticsTrackingEnabled)
        }
    }
}
