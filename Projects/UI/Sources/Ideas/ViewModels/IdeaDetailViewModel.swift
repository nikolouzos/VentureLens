import Core
import Dependencies
import Foundation
import Networking
import SwiftData
import SwiftUICore

@MainActor
class IdeaDetailViewModel: ObservableObject {
    let idea: Idea
    let apiClient: APIClientProtocol
    let authentication: Authentication
    private let analytics: Analytics?
    private let bookmarkDataSource: DataSource<Bookmark>?

    @Published private(set) var currentUser: User?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var selectedTab: DetailTab = .overview
    @Published private(set) var isBookmarked: Bool = false
    @Published private(set) var isPremiumUser: Bool = false
    @Published private(set) var hasUnlockedIdea: Bool = false

    init(
        idea: Idea,
        apiClient: APIClientProtocol,
        authentication: Authentication,
        analytics: Analytics? = nil,
        bookmarkDataSource: DataSource<Bookmark>? = .init(
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .automatic
            )
        )
    ) {
        self.idea = idea
        self.apiClient = apiClient
        self.authentication = authentication
        self.analytics = analytics
        self.bookmarkDataSource = bookmarkDataSource
    }

    func onAppear() {
        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await self.updateBookmark() }
                group.addTask { await self.fetchUser() }

                await group.waitForAll()
            }
        }

        // Track idea view when initialized
        trackIdeaViewed()
    }

    func onDisappear() {
        trackIdeaViewEnded()
    }

    func updateSelectedTab(_ tab: DetailTab) {
        // Track when tab changes
        trackTabChanged(from: selectedTab, to: tab)
        selectedTab = tab
    }

    private func updateBookmark() async {
        isLoading = true
        isBookmarked = await(try? bookmarkDataSource?.fetchSingle(idea.id)) != nil
        isLoading = false
    }

    func toggleBookmark() async {
        isLoading = true
        guard let bookmarkDataSource else {
            isLoading = false
            return
        }

        if isBookmarked {
            // Remove the bookmark
            if await bookmarkDataSource.delete(idea.id) {
                isBookmarked = false
                trackIdeaUnbookmarked()
            }
            isLoading = false
            return
        }

        // Add new bookmark
        if await bookmarkDataSource.append(Bookmark(id: idea.id)) {
            isBookmarked = true
            trackIdeaBookmarked()
        }
        isLoading = false
    }

    private func fetchUser() async {
        currentUser = await authentication.currentUser
        checkSubscriptionStatus()
    }

    private func checkSubscriptionStatus() {
        guard let user = currentUser else { return }

        isPremiumUser = user.subscription == .premium
        hasUnlockedIdea = user.unlockedIdeas.contains(idea.id)
    }

    // MARK: - Analytics Tracking

    private func trackIdeaViewed() {
        analytics?.track(event: .ideaViewed(
            id: idea.id.uuidString,
            title: idea.title,
            category: idea.category
        ))

        analytics?.startTimingEvent(event: .ideaViewed)
    }

    private func trackIdeaViewEnded() {
        analytics?.trackTimedEvent(event: .ideaViewed, additionalProperties: nil)
    }

    private func trackTabChanged(from oldTab: DetailTab, to newTab: DetailTab) {
        // End timing for the old tab
        analytics?.trackTimedEvent(
            event: .ideaTabViewed,
            additionalProperties: ["from_tab": oldTab.title]
        )

        // Track and start timing for the new tab
        analytics?.track(event: .ideaTabViewed(
            ideaId: idea.id.uuidString,
            tabName: newTab.title
        ))

        analytics?.startTimingEvent(event: .ideaTabViewed)
    }

    private func trackIdeaBookmarked() {
        analytics?.track(event: .ideaBookmarked(
            id: idea.id.uuidString,
            title: idea.title
        ))
    }

    private func trackIdeaUnbookmarked() {
        analytics?.track(event: .ideaUnbookmarked(
            id: idea.id.uuidString,
            title: idea.title
        ))
    }
}

// MARK: - Detail Tab Enum

enum DetailTab: String, CaseIterable {
    case overview
    case financial
    case market
    case roadmap
    case techStack
    case ethics
    case validation

    var title: String {
        switch self {
        case .overview: return "Overview"
        case .financial: return "Financial"
        case .market: return "Market"
        case .roadmap: return "Roadmap"
        case .techStack: return "Tech Stack"
        case .ethics: return "Ethics & Risks"
        case .validation: return "MVP Validation"
        }
    }
}
