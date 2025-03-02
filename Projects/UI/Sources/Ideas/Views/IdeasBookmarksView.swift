import AppResources
import Core
import Networking
import SwiftUI

struct IdeasBookmarksView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @StateObject private var viewModel: IdeasBookmarksViewModel
    
    let namespace: Namespace.ID
    let onIdeaTap: (Idea) -> Void
    
    init(viewModel: IdeasBookmarksViewModel, namespace: Namespace.ID, onIdeaTap: @escaping (Idea) -> Void) {
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
                ideas: viewModel.bookmarkedIdeas,
                isLoading: viewModel.isLoading,
                canLoadMore: viewModel.canLoadMore,
                namespace: namespace,
                gridLayout: gridLayout,
                onIdeaTap: onIdeaTap,
                onLoadMore: {
                    Task {
                        await viewModel.loadMoreBookmarkedIdeas()
                    }
                },
                emptyStateTitle: "No bookmarked ideas",
                emptyStateMessage: "Ideas you bookmark will appear here"
            )
        }
    }
}

#if DEBUG
import Networking
import SwiftData

#Preview {
    NavigationView {
        IdeasBookmarksView(
            viewModel: IdeasBookmarksViewModel(
                apiClient: MockAPIClient(),
                authentication: MockAuthentication(accessToken: "mock"),
                bookmarkDataSource: DataSource<Bookmark>(
                    configurations: ModelConfiguration(
                        isStoredInMemoryOnly: true
                    )
                ),
                errorHandler: { _ in }
            ),
            namespace: Namespace().wrappedValue,
            onIdeaTap: { _ in }
        )
    }
    .tint(AppResourcesAsset.Colors.accentColor.swiftUIColor)
}
#endif 
