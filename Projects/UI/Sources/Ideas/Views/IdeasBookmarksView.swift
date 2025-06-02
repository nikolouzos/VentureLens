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
                GridItem(.flexible(minimum: 400)),
            ]
        }
        return [GridItem(.flexible())]
    }

    var body: some View {
        if viewModel.currentUser?.isAnonymous != true {
            IdeasGridView(
                ideas: viewModel.bookmarkedIdeas,
                isLoading: viewModel.isLoading,
                isRefreshing: viewModel.isRefreshing,
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
                emptyStateMessage: "Ideas you bookmark will appear here",
                currentUser: viewModel.currentUser
            )
        } else {
            disabledFeatureView
        }
    }

    private var disabledFeatureView: some View {
        VStack(spacingSize: .xl) {
            Image(systemName: "bookmark.slash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(widthSize: .composite(.xl, .md))
                .foregroundColor(.secondary)

            Text("Bookmarks are not available for guest users")
                .font(.plusJakartaSans(.title3, weight: .semibold))

            Text("Please create a free account to get access to bookmarks")
                .font(.plusJakartaSans(.subheadline))
                .foregroundColor(.secondary)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, .xl)
    }
}

#if DEBUG
    import Dependencies
    import Networking
    import SwiftData

    #Preview {
        NavigationView {
            IdeasBookmarksView(
                viewModel: IdeasBookmarksViewModel(
                    apiClient: Dependencies().apiClient,
                    authentication: Dependencies().authentication,
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
