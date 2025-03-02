import Combine
import Core
import Foundation
import Networking
import SwiftUI

@MainActor
public final class IdeasLiveFeedViewModel: ObservableObject {
    @Published private(set) var ideas: [Idea] = []
    @Published private(set) var isLoading = false
    @Published private(set) var ideasFilters: IdeasFiltersResponse?
    @Published private(set) var currentRequest: IdeasListRequest
    
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
        self.currentRequest = IdeasListRequest()
    }
    
    func updateErrorHandler(_ handler: @escaping (Error) -> Void) {
        self.errorHandler = handler
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
            requestType: .filters(
                query: query,
                category: category,
                createdBefore: createdBefore,
                createdAfter: createdAfter
            )
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
            errorHandler(error)
        }
    }
    
    private func loadIdeas(resetResults: Bool) async {
        guard !isLoading else { return }
        
        isLoading = true
        
        do {
            let nextPage = resetResults ? 1 : (currentRequest.page + 1)
            
            let request: IdeasListRequest
            
            switch currentRequest.requestType {
            case .filters(let query, let category, let createdBefore, let createdAfter):
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
                
            case .ids(let ids):
                request = IdeasListRequest(
                    page: nextPage,
                    pageSize: currentRequest.pageSize,
                    requestType: .ids(ids: ids)
                )
            }
            
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
            errorHandler(error)
        }
        
        isLoading = false
    }
} 
