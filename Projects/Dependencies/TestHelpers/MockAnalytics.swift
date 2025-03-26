import Foundation
@testable import Dependencies

/// Mock implementation of Analytics for testing
public final class MockAnalytics: Analytics {    
    public var isInitialized = false
    public var identifiedUsers: [(uid: String, properties: [String: Any]?)] = []
    public var trackedEvents: [AnalyticsEvent] = []
    public var timedEvents: [AnalyticsEventName] = []
    public var trackedTimedEvents: [(event: AnalyticsEventName, properties: [String: Any]?)] = []
    public var resetCalled = false
    public var isOptedOut = false
    public var optedInUsers: [String?] = []
    
    public init() {}
    
    public func optOut() {
        isOptedOut = true
        reset()
    }
    
    public func optIn(uid: String?) {
        isOptedOut = false
        optedInUsers.append(uid)
    }
    
    public func identify(uid: String, properties: [String: Any]?) {
        guard !isOptedOut else { return }
        identifiedUsers.append((uid: uid, properties: properties))
    }
    
    public func reset() {
        resetCalled = true
        identifiedUsers = []
        trackedEvents = []
        timedEvents = []
        trackedTimedEvents = []
        optedInUsers = []
    }
    
    public func track(event: AnalyticsEvent) {
        guard !isOptedOut else { return }
        trackedEvents.append(event)
    }
    
    public func startTimingEvent(event: AnalyticsEventName) {
        guard !isOptedOut else { return }
        timedEvents.append(event)
    }
    
    public func trackTimedEvent(event: AnalyticsEventName, additionalProperties: [String: Any]?) {
        guard !isOptedOut else { return }
        trackedTimedEvents.append((event: event, properties: additionalProperties))
    }
    
    // MARK: - Helper Methods
    
    /// Check if a specific event was tracked
    public func hasTracked(_ event: AnalyticsEvent) -> Bool {
        trackedEvents.contains { eventMatches($0, event) }
    }
    
    /// Get properties for a tracked event
    public func propertiesForEvent(_ event: AnalyticsEvent) -> [String: Any]? {
        guard let trackedEvent = trackedEvents.first(where: { eventMatches($0, event) }) else {
            return nil
        }
        return trackedEvent.nameAndProperties.properties
    }
    
    /// Check if a specific timed event was started
    public func hasStartedTiming(_ event: AnalyticsEventName) -> Bool {
        timedEvents.contains(event)
    }
    
    /// Check if a specific timed event was tracked
    public func hasTrackedTimedEvent(_ event: AnalyticsEventName) -> Bool {
        trackedTimedEvents.contains { $0.event == event }
    }
    
    /// Get properties for a tracked timed event
    public func propertiesForTimedEvent(_ event: AnalyticsEventName) -> [String: Any]? {
        trackedTimedEvents.first { $0.event == event }?.properties
    }
    
    // MARK: - Private Helpers
    
    private func eventMatches(_ event1: AnalyticsEvent, _ event2: AnalyticsEvent) -> Bool {
        switch (event1, event2) {
        case (.ideaViewed(let id1, let title1, let category1),
              .ideaViewed(let id2, let title2, let category2)):
            return id1 == id2 && title1 == title2 && category1 == category2
            
        case (.ideaTabViewed(let ideaId1, let tabName1),
              .ideaTabViewed(let ideaId2, let tabName2)):
            return ideaId1 == ideaId2 && tabName1 == tabName2
            
        case (.ideaBookmarked(let id1, let title1),
              .ideaBookmarked(let id2, let title2)):
            return id1 == id2 && title1 == title2
            
        case (.ideaUnbookmarked(let id1, let title1),
              .ideaUnbookmarked(let id2, let title2)):
            return id1 == id2 && title1 == title2
            
        case (.appOpened, .appOpened),
             (.appClosed, .appClosed),
             (.userSignedUp, .userSignedUp),
             (.userSignedIn, .userSignedIn),
             (.userSignedOut, .userSignedOut):
            return true
            
        default:
            return false
        }
    }
} 
