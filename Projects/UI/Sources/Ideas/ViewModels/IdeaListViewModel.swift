import Combine
import Core
import Dependencies
import Networking
import SwiftData
import SwiftUICore

@MainActor
public final class IdeaListViewModel: ObservableObject {
    @Published var error: Error?

    let apiClient: APIClientProtocol
    let authentication: Authentication
    let analytics: Analytics
    private let bookmarkDataSource: DataSource<Bookmark>?

    // Child ViewModels
    let liveFeedViewModel: IdeasLiveFeedViewModel
    let bookmarksViewModel: IdeasBookmarksViewModel

    public init(
        dependencies: Dependencies,
        bookmarkDataSource: DataSource<Bookmark>? = .init(
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .automatic
            )
        )
    ) {
        apiClient = dependencies.apiClient
        authentication = dependencies.authentication
        analytics = dependencies.analytics
        self.bookmarkDataSource = bookmarkDataSource

        // Initialize with temporary error handlers that do nothing
        liveFeedViewModel = IdeasLiveFeedViewModel(
            apiClient: apiClient,
            authentication: authentication,
            errorHandler: { _ in }
        )

        bookmarksViewModel = IdeasBookmarksViewModel(
            apiClient: apiClient,
            authentication: authentication,
            bookmarkDataSource: bookmarkDataSource,
            errorHandler: { _ in }
        )

        // Now that self is fully initialized, set up the real error handlers
        setupErrorHandlers()
    }

    private func setupErrorHandlers() {
        // Update the error handlers to use self
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
}
