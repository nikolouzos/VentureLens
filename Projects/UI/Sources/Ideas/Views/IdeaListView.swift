import AppResources
import Core
import Networking
import SwiftData
import SwiftUI

// MARK: - Coordinator View

public struct IdeaListView: View {
    fileprivate enum FeedState: String, CaseIterable {
        case live = "Feed"
        case bookmarks = "Bookmarked"
    }

    @Namespace var ideaNamespace
    @StateObject private var viewModel: IdeaListViewModel
    @State private var presentingIdea: Idea?
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
                    IdeasLiveFeedView(
                        viewModel: viewModel.liveFeedViewModel,
                        namespace: ideaNamespace,
                        onIdeaTap: { idea in
                            presentingIdea = idea
                        }
                    )

                case .bookmarks:
                    IdeasBookmarksView(
                        viewModel: viewModel.bookmarksViewModel,
                        namespace: ideaNamespace,
                        onIdeaTap: { idea in
                            presentingIdea = idea
                        }
                    )
                }
            }
            .toolbar {
                toolbarItems
            }
            .background(
                Color.secondary.opacity(0.05)
                    .ignoresSafeArea(.all)
            )
        }
        .task {
            await viewModel.liveFeedViewModel.fetchIdeas()
        }
        .onChange(of: feedState) { _, newValue in
            if newValue == .bookmarks {
                Task {
                    await viewModel.bookmarksViewModel.fetchBookmarkedIdeas()
                }
            }
        }
        .sheet(item: $presentingIdea, onDismiss: {
            presentingIdea = nil
            // Refresh bookmarks when returning from detail view if needed
            if feedState == .bookmarks {
                Task {
                    await viewModel.bookmarksViewModel.fetchBookmarkedIdeas()
                }
            }
        }) { idea in
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
        .alert(isPresented: .init(
            get: { viewModel.error != nil },
            set: { if !$0 { viewModel.clearError() } }
        )) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.error?.localizedDescription ?? "An unknown error occurred"),
                dismissButton: .default(Text("OK"))
            )
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

    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            AppResourcesAsset.Assets.logo.swiftUIImage
                .resizable()
                .frame(widthSize: .xl, heightSize: .xl)
        }
    }
}

#if DEBUG
    import Networking
    import SwiftData

    #Preview {
        IdeaListView(
            viewModel: IdeaListViewModel(
                apiClient: MockAPIClient(),
                authentication: MockAuthentication(
                    accessToken: "mock"
                ),
                bookmarkDataSource: DataSource<Bookmark>(
                    configurations: ModelConfiguration(
                        isStoredInMemoryOnly: true
                    )
                )
            )
        )
        .tint(AppResourcesAsset.Colors.accentColor.swiftUIColor)
    }

#endif
