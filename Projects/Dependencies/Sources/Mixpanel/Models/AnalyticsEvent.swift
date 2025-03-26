import Foundation

/// Strongly typed analytics events with associated values
public enum AnalyticsEvent {
    // Idea events
    case ideaViewed(id: String, title: String, category: String?)
    case ideaTabViewed(ideaId: String, tabName: String)
    case ideaBookmarked(id: String, title: String)
    case ideaUnbookmarked(id: String, title: String)

    // Session events
    case appOpened
    case appClosed

    // Authentication events
    case userSignedUp
    case userSignedIn
    case userSignedOut

    /// Convert the event to its name and properties
    var nameAndProperties: (name: AnalyticsEventName, properties: [String: Any]?) {
        switch self {
        case let .ideaViewed(id, title, category):
            var properties: [String: Any] = [
                AnalyticsProperties.ideaId: id,
                AnalyticsProperties.ideaTitle: title,
            ]
            if let category = category {
                properties[AnalyticsProperties.ideaCategory] = category
            }
            return (.ideaViewed, properties)

        case let .ideaTabViewed(ideaId, tabName):
            return (.ideaTabViewed, [
                AnalyticsProperties.ideaId: ideaId,
                AnalyticsProperties.tabName: tabName,
            ])

        case let .ideaBookmarked(id, title):
            return (.ideaBookmarked, [
                AnalyticsProperties.ideaId: id,
                AnalyticsProperties.ideaTitle: title,
            ])

        case let .ideaUnbookmarked(id, title):
            return (.ideaUnbookmarked, [
                AnalyticsProperties.ideaId: id,
                AnalyticsProperties.ideaTitle: title,
            ])

        case .appOpened:
            return (.appOpened, nil)

        case .appClosed:
            return (.appClosed, nil)

        case .userSignedUp:
            return (.userSignedUp, nil)

        case .userSignedIn:
            return (.userSignedIn, nil)

        case .userSignedOut:
            return (.userSignedOut, nil)
        }
    }
}
