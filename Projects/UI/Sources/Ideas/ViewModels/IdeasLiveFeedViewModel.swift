import Combine
import Foundation
import Networking
import SwiftUI

@MainActor
public class IdeasLiveFeedViewModel: ObservableObject {
    @Published private(set) var ideas: [Idea] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isRefreshing = false
    @Published private(set) var ideasFilters: IdeasFiltersResponse?
    @Published private(set) var currentRequest: IdeasListRequest
    @Published private(set) var currentUser: User?

    private(set) var canLoadMore = true

    private let apiClient: APIClientProtocol
    private let authentication: Authentication
    private var errorHandler: (Error) -> Void

    public init(
        apiClient: APIClientProtocol,
        authentication: Authentication,
        errorHandler: @escaping (Error) -> Void
    ) {
        self.apiClient = apiClient
        self.authentication = authentication
        self.errorHandler = errorHandler
        currentRequest = IdeasListRequest()
    }

    func updateErrorHandler(_ handler: @escaping (Error) -> Void) {
        errorHandler = handler
    }

    func fetchIdeas(isRefreshing: Bool = false) async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.updateUser() }
            group.addTask { await self.fetchFilters() }
            group.addTask { await self.loadIdeas(resetResults: true, isRefreshing: isRefreshing) }

            await group.waitForAll()
        }
    }

    func loadMoreIdeas() async {
        await loadIdeas(resetResults: false)
    }

    func applyFilters(
        query: String?,
        category: String?,
        createdBefore: String?,
        createdAfter: String?
    ) async {
        currentRequest = IdeasListRequest(
            page: 1,
            pageSize: currentRequest.pageSize,
            requestType: .filters(
                query: query,
                category: category,
                createdBefore: createdBefore,
                createdAfter: createdAfter
            )
        )
        await loadIdeas(resetResults: true)
    }

    private func updateUser() async {
        currentUser = await authentication.currentUser
    }

    private func fetchFilters() async {
        guard !isLoading else { return }

        do {
            let filters: IdeasFiltersResponse = try await apiClient.fetch(.ideasFilters)

            ideasFilters = filters
        } catch {
            errorHandler(error)
        }
    }

    private func loadIdeas(resetResults: Bool, isRefreshing: Bool = false) async {
        guard !isLoading else { return }

        isLoading = true
        self.isRefreshing = isRefreshing

        if resetResults {
            ideas = []
        }

        do {
            let nextPage = resetResults ? 1 : (currentRequest.page + 1)

            let request: IdeasListRequest

            switch currentRequest.requestType {
            case let .filters(query, category, createdBefore, createdAfter):
                request = IdeasListRequest(
                    page: nextPage,
                    pageSize: currentRequest.pageSize,
                    requestType: .filters(
                        query: query,
                        category: category,
                        createdBefore: createdBefore,
                        createdAfter: createdAfter
                    )
                )

            case let .ids(ids):
                request = IdeasListRequest(
                    page: nextPage,
                    pageSize: currentRequest.pageSize,
                    requestType: .ids(ids: ids)
                )
            }

            let response: IdeasListResponse = try await apiClient.fetch(
                .ideasList(request)
            )

            if resetResults {
                ideas = response.ideas
            } else {
                ideas.append(contentsOf: response.ideas)
            }

            canLoadMore = response.ideas.count >= currentRequest.pageSize
            currentRequest = request

        } catch {
            errorHandler(error)
        }

        isLoading = false
        self.isRefreshing = false
    }
}
