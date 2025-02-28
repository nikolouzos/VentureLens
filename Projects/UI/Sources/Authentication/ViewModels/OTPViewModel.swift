import Core
import Foundation
import Networking

public class OTPViewModel: FailableViewModel, ObservableObject {
    private let authentication: Authentication
    let signupEmail: String
    @Published var coordinator: NavigationCoordinator<AuthenticationViewState>
    @Published var otp: String = ""
    @Published public var isLoading: Bool = false
    @Published public var error: Error?
    @Published public var resendCooldown: Int = 60
    private var resendTimer: Timer?
    private var verificationTask: Task<Void, Never>?

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

        // Cancel any existing verification task
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
        resendTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }

            DispatchQueue.main.async {
                if self.resendCooldown > 0 {
                    self.resendCooldown -= 1
                } else {
                    timer.invalidate()
                }
            }
        }
    }

    deinit {
        verificationTask?.cancel()
        resendTimer?.invalidate()
    }
}
