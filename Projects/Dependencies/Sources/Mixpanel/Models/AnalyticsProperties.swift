import Foundation

/// Properties that can be tracked with analytics events
public struct AnalyticsProperties {
    // Idea properties
    public static let ideaId = "idea_id"
    public static let ideaTitle = "idea_title"
    public static let ideaCategory = "idea_category"
    
    // Tab/section properties
    public static let tabName = "tab_name"
    public static let sectionName = "section_name"
    
    // Time tracking properties
    public static let viewDuration = "view_duration"
    public static let sessionDuration = "session_duration"
    
    // User properties
    public static let userId = "user_id"
    public static let userEmail = "user_email"
    
    private init() {}
} 