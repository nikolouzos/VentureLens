import Combine
import Foundation
import Networking

public class IdeaListViewModel: ObservableObject {
    private let apiClient: APIClientProtocol
    private let authentication: Authentication

    @Published var ideas: [Idea] = []
    @Published var isInitialLoading = false
    @Published var isLoadingMore = false
    @Published var showError = false
    @Published var errorMessage = ""

    private var currentPage = 1
    private let pageSize = 10
    private var totalPages = 1

    var isLoading: Bool {
        isInitialLoading || isLoadingMore
    }

    var canLoadMore: Bool {
        currentPage < totalPages
    }

    public init(
        apiClient: APIClientProtocol,
        authentication: Authentication
    ) {
        self.apiClient = apiClient
        self.authentication = authentication
    }

    func fetchIdeas() async {
        guard ideas.isEmpty else { return }
        await setIsLoading(isInitialLoad: true)
        await loadIdeas()
        await setIsLoading(isInitialLoad: false)
    }

    @MainActor
    func refreshIdeas() async {
        ideas = []
        currentPage = 1
        totalPages = 1

        setIsLoading(isInitialLoad: true)
        await loadIdeas()
        setIsLoading(isInitialLoad: false)
    }

    func loadMoreIdeas() async {
        guard !isLoadingMore && canLoadMore else { return }

        await setIsLoading(isInitialLoad: false)
        await loadIdeas()
        await setIsLoading(isInitialLoad: false)
    }

    @MainActor
    private func setIsLoading(isInitialLoad: Bool) {
        isLoadingMore = isInitialLoading == isInitialLoad &&
            !isInitialLoad &&
            !isLoadingMore
        isInitialLoading = isInitialLoad
    }

    @MainActor
    private func loadIdeas() async {
        guard let accessToken = await authentication.accessToken else {
            return
        }

        do {
            let response: IdeasListResponse = try await apiClient.fetch(
                .ideasList(
                    IdeasListRequest(
                        page: currentPage,
                        pageSize: pageSize
                    )
                ),
                accessToken: accessToken
            )

            ideas.append(contentsOf: response.ideas)
            currentPage = response.currentPage
            totalPages = response.totalPages
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
}
