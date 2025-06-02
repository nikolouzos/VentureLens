import Combine
import Dependencies
import Foundation
import Networking
import SwiftUI

@MainActor
class UnlockIdeaViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case success
        case error(String)
        case limitReached(Date)
    }

    private let user: User
    private let ideaId: String
    let dependencies: Dependencies

    @Published private(set) var state: State = .idle
    @Published var showSubscriptionView = false
    var showPaywallView: Binding<Bool>

    init(
        user: User,
        ideaId: String,
        dependencies: Dependencies,
        showPaywallView: Binding<Bool>
    ) {
        self.user = user
        self.ideaId = ideaId
        self.dependencies = dependencies
        self.showPaywallView = showPaywallView

        setDefaultState()
    }

    @MainActor
    func unlockIdea() async {
        state = .loading

        do {
            let response: UnlockIdeaResponse = try await dependencies.apiClient.fetch(
                .unlockIdea(UnlockIdeaRequest(ideaId: ideaId))
            )

            if response.success {
                state = .success
            } else if let nextAvailable = response.nextUnlockAvailable {
                state = .limitReached(nextAvailable)
            } else {
                state = .error(response.message ?? "Failed to unlock idea")
            }
        } catch {
            let defaultMessage = "Unknown error occurred, please try again later."
            switch error {
            case let .common(status, commonError):
                state = .error("\(commonError.message ?? defaultMessage) (\(status))")

            case .unknown:
                state = .error(defaultMessage)
            }
        }
    }

    private func setDefaultState() {
        let oneWeekAgo = Date().addingTimeInterval(-7 * 24 * 60 * 60)
        let unlockTimeHasElapsed = user.lastUnlockTime == nil || user.lastUnlockTime! < oneWeekAgo

        if user.weeklyUnlocksUsed >= 1, !unlockTimeHasElapsed {
            let lastUnlockTime = user.lastUnlockTime ?? Date()
            let nextUnlockTime = lastUnlockTime.addingTimeInterval(7 * 24 * 60 * 60)
            state = .limitReached(nextUnlockTime)
        }
    }
}
