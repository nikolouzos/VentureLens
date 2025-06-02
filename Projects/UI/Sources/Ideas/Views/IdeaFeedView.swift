import AppResources
import Core
import Networking
import SwiftData
import SwiftUI

public struct IdeaFeedView: View {
    @Namespace var ideaNamespace
    @StateObject private var viewModel: IdeaFeedViewModel
    @State private var presentingIdea: Idea?

    public init(viewModel: IdeaFeedViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            ScrollView {
                feedPicker

                switch viewModel.feedState {
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
            .refreshable {
                viewModel.refreshFeed()
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
            viewModel.refreshFeed(fromViewTask: true)
        }
        .onChange(of: viewModel.feedState) { _, _ in
            viewModel.refreshFeed()
        }
        .sheet(item: $presentingIdea) { idea in
            ideaDetails(for: idea)
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
            Picker(selection: $viewModel.feedState) {
                ForEach(IdeaFeedViewModel.FeedState.allCases, id: \.rawValue) { value in
                    Text(value.rawValue)
                        .tag(value)
                }
            } label: {}
        } label: {
            HStack {
                Text(viewModel.feedState.rawValue)
                    .font(.plusJakartaSans(.largeTitle, weight: .bold))

                Image(systemName: "chevron.down")
                    .offset(y: 2)
            }
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
                .foregroundStyle(Color.tint)
        }
    }

    private func ideaDetails(for idea: Idea) -> some View {
        NavigationStack {
            IdeaDetailView(
                viewModel: IdeaDetailViewModel(
                    idea: idea,
                    dependencies: viewModel.dependencies,
                    onIdeaRefreshed: viewModel.refreshIdea(for:)
                )
            )
        }
        .navigationTransition(
            .zoom(sourceID: idea.id, in: ideaNamespace)
        )
        .presentationDetents([.large])
    }
}

#if DEBUG
    import Dependencies
    import SwiftData

    #Preview {
        IdeaFeedView(
            viewModel: IdeaFeedViewModel(
                dependencies: Dependencies()
            )
        )
        .tint(AppResourcesAsset.Colors.accentColor.swiftUIColor)
    }

#endif
