import Combine
import Dependencies
import Foundation
import Networking

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
    private let apiClient: APIClientProtocol

    @Published private(set) var state: State = .idle

    init(
        user: User,
        ideaId: String,
        apiClient: APIClientProtocol,
        authentication _: Authentication
    ) {
        self.user = user
        self.ideaId = ideaId
        self.apiClient = apiClient

        setDefaultState()
    }

    @MainActor
    func unlockIdea() async {
        state = .loading

        do {
            let response: UnlockIdeaResponse = try await apiClient.fetch(
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
            state = .error(error.localizedDescription)
        }
    }

    private func setDefaultState() {
        let oneWeekAgo = Date().addingTimeInterval(-7 * 24 * 60 * 60)
        let unlockTimeHasElapsed = user.lastUnlockTime == nil || user.lastUnlockTime! < oneWeekAgo

        if user.weeklyUnlocksUsed >= 1 && !unlockTimeHasElapsed {
            let lastUnlockTime = user.lastUnlockTime ?? Date()
            let nextUnlockTime = lastUnlockTime.addingTimeInterval(7 * 24 * 60 * 60)
            state = .limitReached(nextUnlockTime)
        }
    }
}
