import AppResources
import SwiftUI

public struct IdeaListView: View {
    @StateObject private var viewModel: IdeaListViewModel

    public init(viewModel: IdeaListViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            ideaList
                .toolbar {
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
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            Task {
                                await viewModel.refreshIdeas()
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
                .alert(isPresented: $viewModel.showError) {
                    Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
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
                    NavigationLink(destination: IdeaDetailView(idea: idea)) {
                        IdeaCardView(idea: idea)
                    }
                    .buttonStyle(PlainButtonStyle())
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
            .padding()
        }
    }
}

#if DEBUG
    import AppResources
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
