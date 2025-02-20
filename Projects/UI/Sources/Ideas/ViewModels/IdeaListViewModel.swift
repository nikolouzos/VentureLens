import Combine
import Foundation
import Networking

@MainActor
public final class IdeaListViewModel: ObservableObject {
    @Published private(set) var ideas: [Idea] = []
    @Published private(set) var isLoading = false
    @Published var showError = false
    @Published private(set) var ideasFilters: IdeasFiltersResponse?
    @Published private(set) var currentRequest: IdeasListRequest
    
    private(set) var errorMessage = ""
    private(set) var canLoadMore = true
    
    private let apiClient: APIClientProtocol
    private let authentication: Authentication
    
    public init(
        apiClient: APIClientProtocol,
        authentication: Authentication
    ) {
        self.apiClient = apiClient
        self.authentication = authentication
        self.currentRequest = IdeasListRequest()
    }
    
    func fetchIdeas() async {
        Task {
            await fetchFilters()
        }
        Task {
            await loadIdeas(resetResults: true)
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
            query: query,
            category: category,
            createdBefore: createdBefore,
            createdAfter: createdAfter
        )
        await loadIdeas(resetResults: true)
    }
    
    private func fetchFilters() async {
        guard !isLoading else { return }
        
        do {
            guard let accessToken = await authentication.accessToken else { return }
            
            let filters: IdeasFiltersResponse = try await apiClient.fetch(
                .ideasFilters,
                accessToken: accessToken
            )
            
            ideasFilters = filters
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
    
    private func loadIdeas(resetResults: Bool) async {
        guard !isLoading else { return }
        
        isLoading = true
        
        do {
            let request = IdeasListRequest(
                page: resetResults ? 1 : currentRequest.page + 1,
                pageSize: currentRequest.pageSize,
                query: currentRequest.query,
                category: currentRequest.category,
                createdBefore: currentRequest.createdBefore,
                createdAfter: currentRequest.createdAfter
            )
            
            guard let accessToken = await authentication.accessToken else {
                isLoading = false
                return
            }
            
            let response: IdeasListResponse = try await apiClient.fetch(
                .ideasList(request),
                accessToken: accessToken
            )
            
            if resetResults {
                ideas = response.ideas
            } else {
                ideas.append(contentsOf: response.ideas)
            }
            
            canLoadMore = response.ideas.count >= currentRequest.pageSize
            currentRequest = request
            
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
