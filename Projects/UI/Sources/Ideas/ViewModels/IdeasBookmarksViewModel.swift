import Combine
import Core
import Foundation
import Networking
import SwiftData
import SwiftUI

@MainActor
public final class IdeasBookmarksViewModel: ObservableObject {
    @Published private(set) var bookmarkedIdeas: [Idea] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isRefreshing = false
    @Published private(set) var currentUser: User?

    private(set) var canLoadMore = true
    private(set) var currentPage = 1
    private let pageSize = 20

    private let apiClient: APIClientProtocol
    private let authentication: Authentication
    private let bookmarkDataSource: DataSource<Bookmark>?
    private var errorHandler: (Error) -> Void

    public init(
        apiClient: APIClientProtocol,
        authentication: Authentication,
        bookmarkDataSource: DataSource<Bookmark>?,
        errorHandler: @escaping (Error) -> Void
    ) {
        self.apiClient = apiClient
        self.authentication = authentication
        self.bookmarkDataSource = bookmarkDataSource
        self.errorHandler = errorHandler
    }

    func updateErrorHandler(_ handler: @escaping (Error) -> Void) {
        errorHandler = handler
    }

    func fetchBookmarkedIdeas() async {
        Task {
            await fetchCurrentUser()
        }
        await loadBookmarkedIdeas(resetResults: true)
    }

    func loadMoreBookmarkedIdeas() async {
        await loadBookmarkedIdeas(resetResults: false)
    }

    private func fetchCurrentUser() async {
        currentUser = await authentication.currentUser
    }

    private func loadBookmarkedIdeas(resetResults: Bool, isRefreshing: Bool = false) async {
        guard !isLoading, let bookmarkDataSource = bookmarkDataSource else {
            return
        }

        isLoading = true
        self.isRefreshing = isRefreshing

        if resetResults {
            currentPage = 1
            bookmarkedIdeas = []
        } else {
            currentPage += 1
        }

        do {
            // Fetch bookmarked idea IDs from SwiftData
            let bookmarks = try await bookmarkDataSource.fetch()
            let bookmarkIds = bookmarks.compactMap { $0.id?.uuidString }

            guard !bookmarkIds.isEmpty else {
                if resetResults {
                    bookmarkedIdeas = []
                }
                isLoading = false
                self.isRefreshing = false
                return
            }

            // Create a request for bookmarked ideas
            let request = IdeasListRequest(
                page: currentPage,
                pageSize: pageSize,
                requestType: .ids(ids: bookmarkIds)
            )

            let response: IdeasListResponse = try await apiClient.fetch(
                .ideasList(request)
            )

            if resetResults {
                bookmarkedIdeas = response.ideas
            } else {
                bookmarkedIdeas.append(contentsOf: response.ideas)
            }

            canLoadMore = response.ideas.count >= pageSize

        } catch {
            errorHandler(error)
        }

        isLoading = false
        self.isRefreshing = false
    }
}
