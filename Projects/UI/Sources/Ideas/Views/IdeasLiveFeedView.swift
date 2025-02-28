import AppResources
import Core
import Networking
import SwiftUI

struct IdeasLiveFeedView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @StateObject private var viewModel: IdeasLiveFeedViewModel
    @State private var showingFilters = false
    
    let namespace: Namespace.ID
    let onIdeaTap: (Idea) -> Void
    
    init(viewModel: IdeasLiveFeedViewModel, namespace: Namespace.ID, onIdeaTap: @escaping (Idea) -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.namespace = namespace
        self.onIdeaTap = onIdeaTap
    }
    
    private var gridLayout: [GridItem] {
        if horizontalSizeClass == .regular {
            // 2 columns
            return [
                GridItem(.flexible(minimum: 400)),
                GridItem(.flexible(minimum: 400))
            ]
        }
        return [GridItem(.flexible())]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }
            
            IdeasGridView(
                ideas: viewModel.ideas,
                isLoading: viewModel.isLoading,
                canLoadMore: viewModel.canLoadMore,
                namespace: namespace,
                gridLayout: gridLayout,
                onIdeaTap: onIdeaTap,
                onLoadMore: {
                    Task {
                        await viewModel.loadMoreIdeas()
                    }
                }
            )
        }
        .sheet(isPresented: $showingFilters) {
            IdeaFiltersView(
                viewModel: IdeaFiltersViewModel(
                    currentRequest: viewModel.currentRequest,
                    filters: viewModel.ideasFilters!
                ) { query, category, createdBefore, createdAfter in
                    Task {
                        await viewModel.applyFilters(
                            query: query,
                            category: category,
                            createdBefore: createdBefore,
                            createdAfter: createdAfter
                        )
                    }
                }
            )
            .presentationDetents([.medium, .large])
        }
        .toolbar {
            if viewModel.ideasFilters != nil {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingFilters = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
    }
}

#if DEBUG
import Networking
import SwiftData

#Preview {
    NavigationView {
        IdeasLiveFeedView(
            viewModel: IdeasLiveFeedViewModel(
                apiClient: MockAPIClient(),
                authentication: MockAuthentication(accessToken: "mock"),
                errorHandler: { _ in }
            ),
            namespace: Namespace().wrappedValue,
            onIdeaTap: { _ in }
        )
    }
    .tint(AppResourcesAsset.Colors.accentColor.swiftUIColor)
}
#endif 
