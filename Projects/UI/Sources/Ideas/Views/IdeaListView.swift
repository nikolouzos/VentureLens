import AppResources
import SwiftUI

public struct IdeaListView: View {
    @Namespace var ideaNamespace
    @StateObject private var viewModel: IdeaListViewModel
    @State private var presentingIdea: Idea?
    @State private var showingFilters = false
    
    public init(viewModel: IdeaListViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    public var body: some View {
        NavigationView {
            ideaList
                .toolbar {
                    toolbarItems
                }
                .alert(isPresented: $viewModel.showError) {
                    Alert(
                        title: Text("Error"),
                        message: Text(viewModel.errorMessage),
                        dismissButton: .default(Text("OK"))
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
        }
        .task {
            await viewModel.fetchIdeas()
        }
    }
    
    private var ideaList: some View {
        ScrollView {
            LazyVStack(spacingSize: .lg) {
                ForEach(viewModel.ideas) { idea in
                    IdeaCardView(idea: idea)
                        .matchedTransitionSource(id: idea.id, in: ideaNamespace)
                        .onTapGesture {
                            presentingIdea = idea
                        }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
                
                if !viewModel.isLoading && viewModel.canLoadMore {
                    Button("Load More") {
                        Task {
                            await viewModel.loadMoreIdeas()
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(item: $presentingIdea, onDismiss: { presentingIdea = nil }) { idea in
            NavigationStack {
                IdeaDetailView(idea: idea)
                    .navigationTransition(
                        .zoom(sourceID: idea.id, in: ideaNamespace)
                    )
            }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            AppResourcesAsset.Assets.puzzleBulb.swiftUIImage
                .resizable()
                .frame(widthSize: .xl, heightSize: .xl)
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color.themeSecondary,
                            Color.themeSecondary,
                            Color.accentColor,
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        
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

#if DEBUG
import Networking

#Preview {
    IdeaListView(
        viewModel: IdeaListViewModel(
            apiClient: MockAPIClient(),
            authentication: AuthenticationMock()
        )
    )
    .tint(AppResourcesAsset.Colors.accentColor.swiftUIColor)
}

#endif
