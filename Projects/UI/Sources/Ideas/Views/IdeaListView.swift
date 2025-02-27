import AppResources
import Core
import Networking
import SwiftUI

public struct IdeaListView: View {
    fileprivate enum FeedState: String, CaseIterable {
        case live = "Feed"
        case bookmarks = "Bookmarked"
    }
    
    @Namespace var ideaNamespace
    @StateObject private var viewModel: IdeaListViewModel
    @State private var presentingIdea: Idea?
    @State private var showingFilters = false
    @State private var feedState: FeedState = .live
    
    public init(viewModel: IdeaListViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                feedPicker
                
                switch feedState {
                case .live:
                    liveFeed
                    
                case .bookmarks:
                    Text("Bookmarks")
                }
            }
            .toolbar {
                toolbarItems
            }
        }
        .task {
            await viewModel.fetchIdeas()
        }
    }
    
    private var feedPicker: some View {
        Menu {
            Picker(selection: $feedState) {
                ForEach(FeedState.allCases, id: \.rawValue) { value in
                    Text(value.rawValue)
                        .tag(value)
                }
            } label: {
                Text(feedState.rawValue)
            }
        } label: {
            HStack {
                Text(feedState.rawValue)
                    .font(.largeTitle)
                
                Image(systemName: "chevron.down")
                    .font(.title3)
                    .offset(y: 2)
            }
            .fontWeight(.bold)
            .foregroundStyle(Color.systemLabel)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, .lg)
    }
    
    private var liveFeed: some View {
        ideaList
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
    
    private var ideaList: some View {
        LazyVStack(spacingSize: .lg) {
            ForEach(viewModel.ideas) { idea in
                IdeaCardView(idea: idea)
                    .onTapGesture {
                        presentingIdea = idea
                    }
                    .matchedTransitionSource(id: idea.id, in: ideaNamespace)
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
        .sheet(item: $presentingIdea, onDismiss: { presentingIdea = nil }) { idea in
            NavigationStack {
                IdeaDetailView(
                    viewModel: IdeaDetailsViewModel(
                        idea: idea
                    )
                )
                    .navigationTransition(
                        .zoom(sourceID: idea.id, in: ideaNamespace)
                    )
            }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            AppResourcesAsset.Assets.logo.swiftUIImage
                .resizable()
                .frame(widthSize: .xl, heightSize: .xl)
        }
        
        if feedState == .live && viewModel.ideasFilters != nil {
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
            authentication: MockAuthentication(
                accessToken: "mock"
            )
        )
    )
    .tint(AppResourcesAsset.Colors.accentColor.swiftUIColor)
}

#endif
