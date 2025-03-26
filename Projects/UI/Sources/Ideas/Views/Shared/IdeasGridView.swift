import AppResources
import Core
import Networking
import SwiftUI

struct IdeasGridView: View {
    let ideas: [Idea]
    let isLoading: Bool
    let canLoadMore: Bool
    let namespace: Namespace.ID
    let gridLayout: [GridItem]
    let onIdeaTap: (Idea) -> Void
    let onLoadMore: () -> Void
    let emptyStateTitle: String
    let emptyStateMessage: String
    
    init(
        ideas: [Idea],
        isLoading: Bool,
        canLoadMore: Bool,
        namespace: Namespace.ID,
        gridLayout: [GridItem],
        onIdeaTap: @escaping (Idea) -> Void,
        onLoadMore: @escaping () -> Void,
        emptyStateTitle: String = "No ideas found",
        emptyStateMessage: String = "Try adjusting your filters"
    ) {
        self.ideas = ideas
        self.isLoading = isLoading
        self.canLoadMore = canLoadMore
        self.namespace = namespace
        self.gridLayout = gridLayout
        self.onIdeaTap = onIdeaTap
        self.onLoadMore = onLoadMore
        self.emptyStateTitle = emptyStateTitle
        self.emptyStateMessage = emptyStateMessage
    }
    
    var body: some View {
        LazyVGrid(columns: gridLayout, alignment: .center, spacing: Size.lg.rawValue) {
            if ideas.isEmpty && !isLoading {
                emptyStateView
            } else {
                ForEach(ideas) { idea in
                    IdeaCardView(idea: idea)
                        .onTapGesture {
                            onIdeaTap(idea)
                        }
                        .matchedTransitionSource(id: idea.id, in: namespace)
                }
                
                if !isLoading && canLoadMore {
                    loadMoreButton
                }
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "bookmark.slash")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text(emptyStateTitle)
                .font(.plusJakartaSans(.headline))

            Text(emptyStateMessage)
                .font(.plusJakartaSans(.subheadline))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }

    private var loadMoreButton: some View {
        Button("Load More") {
            onLoadMore()
        }
        .padding()
    }
}

#if DEBUG
import Networking

#Preview {
    IdeasGridView(
        ideas: [],
        isLoading: false,
        canLoadMore: false,
        namespace: Namespace().wrappedValue,
        gridLayout: [GridItem(.flexible())],
        onIdeaTap: { _ in },
        onLoadMore: {}
    )
}
#endif 