import Combine
import Core
import Dependencies
import Networking
import SwiftData
import SwiftUICore

@MainActor
public final class IdeaFeedViewModel: ObservableObject {
    public enum FeedState: String, CaseIterable, Sendable {
        case live = "Feed"
        case bookmarks = "Bookmarks"
    }

    @Published var feedState: FeedState = .live
    @Published var error: Error?
    @Published var isInitialLoad: Bool = true

    let dependencies: Dependencies
    let liveFeedViewModel: IdeasLiveFeedViewModel
    let bookmarksViewModel: IdeasBookmarksViewModel

    public init(
        dependencies: Dependencies,
        bookmarkDataSource: DataSource<Bookmark>? = .init(
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .automatic
            )
        ),
        initialFeedState: FeedState = .live
    ) {
        feedState = initialFeedState
        self.dependencies = dependencies

        liveFeedViewModel = IdeasLiveFeedViewModel(
            apiClient: dependencies.apiClient,
            authentication: dependencies.authentication,
            errorHandler: { _ in }
        )

        bookmarksViewModel = IdeasBookmarksViewModel(
            apiClient: dependencies.apiClient,
            authentication: dependencies.authentication,
            bookmarkDataSource: bookmarkDataSource,
            errorHandler: { _ in }
        )

        setupErrorHandlers()
    }

    func refreshFeed(fromViewTask: Bool = false) {
        Task {
            switch feedState {
            case .live:
                // If we are coming from view .task, load only the first time
                // Otherwise, refresh normally
                if !fromViewTask || (fromViewTask && isInitialLoad) {
                    await liveFeedViewModel.fetchIdeas()
                }

            case .bookmarks:
                await bookmarksViewModel.fetchBookmarkedIdeas()
            }

            isInitialLoad = false
        }
    }

    private func setupErrorHandlers() {
        liveFeedViewModel.updateErrorHandler { [weak self] error in
            self?.error = error
        }

        bookmarksViewModel.updateErrorHandler { [weak self] error in
            self?.error = error
        }
    }

    func clearError() {
        error = nil
    }

    @Sendable
    nonisolated func refreshIdea(for ideaId: UUID) async -> Idea? {
        switch await feedState {
        case .live:
            return await liveFeedViewModel.refreshIdea(id: ideaId)

        case .bookmarks:
            return await bookmarksViewModel.refreshIdea(id: ideaId)
        }
    }
}
