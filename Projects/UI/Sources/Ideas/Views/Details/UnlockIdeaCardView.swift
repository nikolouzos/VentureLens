import AppResources
import SwiftUI

struct UnlockIdeaCardView: View {
    @ObservedObject var viewModel: UnlockIdeaViewModel
    let onUnlocked: () -> Void

    var body: some View {
        VStack(spacingSize: .md) {
            Image(systemName: "lock.shield.fill")
                .font(.title)
                .foregroundStyle(Color.themePrimary)

            Text("Premium Content")
                .font(.plusJakartaSans(.title3, weight: .bold))

            Text("Parts of this idea are only available to premium subscribers or can be unlocked with your free weekly unlock.")
                .font(.plusJakartaSans(.subheadline))
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            if case .loading = viewModel.state {
                ProgressView()
                    .padding()
            } else if case .success = viewModel.state {
                VStack(spacingSize: .sm) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)

                    Text("Unlocked Successfully!")
                        .font(.plusJakartaSans(.headline, weight: .bold))
                }
            } else if case let .error(message) = viewModel.state {
                Text(message)
                    .multilineTextAlignment(.center)
                    .font(.plusJakartaSans(.subheadline))
                    .foregroundColor(.themePrimary)

                Button("Try Again") {
                    unlockContent()
                }
                .buttonStyle(ProminentButtonStyle())

            } else if case let .limitReached(nextDate) = viewModel.state {
                VStack(spacingSize: .sm) {
                    Text("Weekly Limit Reached")
                        .font(.plusJakartaSans(.headline, weight: .bold))
                        .foregroundColor(.orange)

                    Text("Your next free unlock will be available on:")
                        .font(.plusJakartaSans(.subheadline))

                    Text(nextDate, style: .date)
                        .font(.plusJakartaSans(.subheadline, weight: .bold))

                    Button("View Premium Plans") {
                        viewModel.showPaywallView.wrappedValue = true
                    }
                    .buttonStyle(ProminentButtonStyle())
                }
            } else {
                Button("Unlock Content") {
                    unlockContent()
                }
                .buttonStyle(ProminentButtonStyle())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.all, .lg)
        .background(
            RoundedRectangle(cornerSize: .md)
                .fill(Color.secondary.opacity(0.1))
        )
    }

    private func unlockContent() {
        Task {
            await viewModel.unlockIdea()
            if case .success = viewModel.state {
                try await Task.sleep(for: .seconds(1.5))
                onUnlocked()
            }
        }
    }
}

// #if DEBUG
//    import Networking
//
//    struct UnlockIdeaCardPreviews: PreviewProvider {
//        static var previews: some View {
//            Group {
//                UnlockIdeaCardView(
//                    viewModel: UnlockIdeaViewModel(
//                        user: User.mock,
//                        ideaId: UUID().uuidString,
//                        apiClient: MockAPIClient(),
//                        authentication: MockAuthentication()
//                    ),
//                    onUnlocked: {}
//                )
//                .previewDisplayName("Idle State")
//
//                // Loading state
//                UnlockIdeaCardView(
//                    viewModel: {
//                        let apiClient = MockAPIClient()
//                        let authentication = MockAuthentication()
//                        let vm = UnlockIdeaViewModel(
//                            user: User.mock,
//                            ideaId: UUID().uuidString,
//                            apiClient: apiClient,
//                            authentication: authentication
//                        )
//                        Task {
//                            authentication.accessToken = "mock token"
//                            apiClient.overrideResponse = {
//                                try await Task.sleep(for: .seconds(999))
//                                return Data()
//                            }
//                            await vm.unlockIdea()
//                        }
//                        return vm
//                    }(),
//                    onUnlocked: {}
//                )
//                .previewDisplayName("Loading State")
//
//                // Error state
//                UnlockIdeaCardView(
//                    viewModel: {
//                        let apiClient = MockAPIClient()
//                        let authentication = MockAuthentication()
//                        let vm = UnlockIdeaViewModel(
//                            user: User.mock,
//                            ideaId: UUID().uuidString,
//                            apiClient: apiClient,
//                            authentication: authentication
//                        )
//                        Task {
//                            authentication.accessToken = "mock token"
//                            apiClient.overrideResponse = {
//                                UnlockIdeaResponse(
//                                    success: false,
//                                    message: nil,
//                                    unlockedIdeas: nil,
//                                    nextUnlockAvailable: nil
//                                )
//                            }
//                            await vm.unlockIdea()
//                        }
//                        return vm
//                    }(),
//                    onUnlocked: {}
//                )
//                .previewDisplayName("Error State")
//
//                // Success state
//                UnlockIdeaCardView(
//                    viewModel: {
//                        let authentication = MockAuthentication()
//                        authentication.accessToken = "mock token"
//                        let vm = UnlockIdeaViewModel(
//                            user: User.mock,
//                            ideaId: UUID().uuidString,
//                            apiClient: MockAPIClient(),
//                            authentication: authentication
//                        )
//
//                        Task {
//                            await vm.unlockIdea()
//                        }
//                        return vm
//                    }(),
//                    onUnlocked: {}
//                )
//                .previewDisplayName("Success State")
//
//                // Limit reached state
//                UnlockIdeaCardView(
//                    viewModel: {
//                        let apiClient = MockAPIClient()
//                        let authentication = MockAuthentication()
//                        let vm = UnlockIdeaViewModel(
//                            user: User.mock,
//                            ideaId: UUID().uuidString,
//                            apiClient: apiClient,
//                            authentication: authentication
//                        )
//                        Task {
//                            authentication.accessToken = "mock token"
//                            apiClient.overrideResponse = {
//                                UnlockIdeaResponse(
//                                    success: false,
//                                    message: nil,
//                                    unlockedIdeas: nil,
//                                    nextUnlockAvailable: Date()
//                                )
//                            }
//                            await vm.unlockIdea()
//                        }
//                        return vm
//                    }(),
//                    onUnlocked: {}
//                )
//                .previewDisplayName("Limit Reached State")
//            }
//            .padding(.horizontal)
//        }
//    }
// #endif
