import Core
import Dependencies
import Foundation
import Networking
import SwiftData
import SwiftUICore

@MainActor
class IdeaDetailViewModel: ObservableObject {
    let dependencies: Dependencies
    private let bookmarkDataSource: DataSource<Bookmark>?
    private let onIdeaRefreshed: (@Sendable (UUID) async -> Idea?)?

    @Published private(set) var idea: Idea
    @Published private(set) var currentUser: User?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var selectedTab: DetailTab = .overview
    @Published private(set) var isBookmarked: Bool = false
    @Published private(set) var isPremiumUser: Bool = false
    @Published private(set) var hasUnlockedIdea: Bool = false
    @Published private(set) var error: String?
    @Published var showPaywallView: Bool = false

    init(
        idea: Idea,
        dependencies: Dependencies,
        bookmarkDataSource: DataSource<Bookmark>? = .init(
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .automatic
            )
        ),
        onIdeaRefreshed: (@Sendable (UUID) async -> Idea?)? = nil
    ) {
        self.idea = idea
        self.dependencies = dependencies
        self.bookmarkDataSource = bookmarkDataSource
        self.onIdeaRefreshed = onIdeaRefreshed
    }

    func onAppear(hasUnlockedIdea: Bool = false) {
        updateData(
            shouldUpdateIdea: hasUnlockedIdea
        )
        trackIdeaViewed()
    }

    func onDisappear() {
        trackIdeaViewEnded()
    }

    private func updateData(
        shouldUpdateIdea: Bool
    ) {
        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await self.updateBookmark() }
                group.addTask { await self.fetchUser() }

                if shouldUpdateIdea, let onIdeaRefreshed {
                    group.addTask {
                        if let newIdea = await onIdeaRefreshed(self.idea.id) {
                            await MainActor.run {
                                self.idea = newIdea
                            }
                        }
                    }
                }

                await group.waitForAll()
            }
        }
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
        currentUser = await dependencies.authentication.currentUser
        checkSubscriptionStatus()
    }

    private func checkSubscriptionStatus() {
        guard let user = currentUser else { return }

        isPremiumUser = user.subscription == .premium
        hasUnlockedIdea = user.unlockedIdeas.contains(idea.id)
    }

    // MARK: - Analytics Tracking

    private func trackIdeaViewed() {
        dependencies.analytics.track(event: .ideaViewed(
            id: idea.id.uuidString,
            title: idea.title,
            category: idea.category
        ))

        dependencies.analytics.startTimingEvent(event: .ideaViewed)
    }

    private func trackIdeaViewEnded() {
        dependencies.analytics.trackTimedEvent(event: .ideaViewed, additionalProperties: nil)
    }

    private func trackTabChanged(from oldTab: DetailTab, to newTab: DetailTab) {
        // End timing for the old tab
        dependencies.analytics.trackTimedEvent(
            event: .ideaTabViewed,
            additionalProperties: ["from_tab": oldTab.title]
        )

        // Track and start timing for the new tab
        dependencies.analytics.track(event: .ideaTabViewed(
            ideaId: idea.id.uuidString,
            tabName: newTab.title
        ))

        dependencies.analytics.startTimingEvent(event: .ideaTabViewed)
    }

    private func trackIdeaBookmarked() {
        dependencies.analytics.track(event: .ideaBookmarked(
            id: idea.id.uuidString,
            title: idea.title
        ))
    }

    private func trackIdeaUnbookmarked() {
        dependencies.analytics.track(event: .ideaUnbookmarked(
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
        case .overview: "Overview"
        case .financial: "Financial"
        case .market: "Market"
        case .roadmap: "Roadmap"
        case .techStack: "Tech Stack"
        case .ethics: "Ethics & Risks"
        case .validation: "MVP Validation"
        }
    }
}
