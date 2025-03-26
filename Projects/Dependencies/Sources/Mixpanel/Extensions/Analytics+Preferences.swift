import Foundation
import Mixpanel

/// Extension to provide consistent methods for handling user tracking preferences
public extension Analytics {
    /// Enable tracking and save user preference
    func enableTracking(userId: String?) {
        UserDefaults.standard.isAnalyticsTrackingEnabled = true
        optIn(uid: userId ?? UUID().uuidString)
    }
    
    /// Disable tracking and save user preference
    func disableTracking() {
        UserDefaults.standard.isAnalyticsTrackingEnabled = false
        optOut()
    }
} 
