import Combine
import Core
import Foundation
import Networking

public final class OTPViewModel: ObservableObject {
    private let authentication: Authentication
    let signupEmail: String
    @Published var coordinator: NavigationCoordinator<AuthenticationViewState>
    @Published public var isLoading: Bool = false
    @Published public var error: Error?
    @Published public var resendCooldown: Int = 60
    private var resendTimer: Timer?
    private var verificationTask: Task<Void, Never>?
    private var timerCancellable: Cancellable?

    public init(
        authentication: Authentication,
        coordinator: NavigationCoordinator<AuthenticationViewState>,
        signupEmail: String
    ) {
        self.authentication = authentication
        self.coordinator = coordinator
        self.signupEmail = signupEmail
        startResendCooldown()
    }

    @MainActor
    public func verifyOTP(_ otp: String) {
        guard otp.count == 6, !isLoading else { return }
        isLoading = true

        verificationTask?.cancel()
        verificationTask = Task { @MainActor in
            do {
                try await authentication.verifyOTP(email: signupEmail, token: otp)
                if !Task.isCancelled {
                    coordinator.reset()
                }
            } catch {
                if !Task.isCancelled {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }

    @MainActor
    public func resendCode() {
        guard resendCooldown == 0, !isLoading else { return }
        isLoading = true

        Task {
            do {
                try await authentication.authenticate(with: .otp(email: signupEmail))
                startResendCooldown()
            } catch {
                self.error = error
            }
            isLoading = false
        }
    }

    private func startResendCooldown() {
        resendCooldown = 60
        resendTimer?.invalidate()
        timerCancellable = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { _ in
                if self.resendCooldown > 0 {
                    self.resendCooldown -= 1
                } else {
                    self.timerCancellable?.cancel()
                }
            }
    }

    deinit {
        verificationTask?.cancel()
        resendTimer?.invalidate()
    }
}
