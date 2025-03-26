import Foundation

/// Raw event names for analytics tracking
public enum AnalyticsEventName: String {
    // Idea interaction events
    case ideaViewed = "Idea Viewed"
    case ideaTabViewed = "Idea Tab Viewed"
    case ideaBookmarked = "Idea Bookmarked"
    case ideaUnbookmarked = "Idea Unbookmarked"
    
    // Session events
    case appOpened = "App Opened"
    case appClosed = "App Closed"
    
    // Authentication events
    case userSignedUp = "User Signed Up"
    case userSignedIn = "User Signed In"
    case userSignedOut = "User Signed Out"
} 