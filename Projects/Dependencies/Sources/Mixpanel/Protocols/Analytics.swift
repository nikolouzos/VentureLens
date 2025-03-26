import Foundation

/// Protocol defining the analytics service interface
public protocol Analytics {
    /// Opt out of all tracking and delete any stored user data
    func optOut()

    /// Opt back into tracking with an optional user identifier
    /// - Parameter uid: The unique identifier for the user to associate with future events
    func optIn(uid: String?)

    /// Identify a user in the analytics service
    /// - Parameters:
    ///   - uid: The unique identifier for the user
    ///   - properties: Additional user properties to track
    func identify(uid: String, properties: [String: Any]?)

    /// Reset the user identity when they sign out
    func reset()

    /// Track an event in the analytics service
    /// - Parameter event: The event to track with its associated data
    func track(event: AnalyticsEvent)

    /// Start timing an event
    /// - Parameter event: The event to time
    func startTimingEvent(event: AnalyticsEventName)

    /// Track a timed event with the duration since `startTimingEvent` was called
    /// - Parameters:
    ///   - event: The event to track
    ///   - additionalProperties: Additional properties to add to the event
    func trackTimedEvent(event: AnalyticsEventName, additionalProperties: [String: Any]?)
}
