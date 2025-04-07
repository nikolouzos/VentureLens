import AppResources
import Combine
import SwiftUI

public struct OTPView: View {
    @StateObject var viewModel: OTPViewModel

    public init(viewModel: OTPViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(alignment: .center, spacingSize: .xl) {
            (
                Text("Please enter the One-Time Password you received on ") +
                    Text(viewModel.signupEmail)
                    .font(.plusJakartaSans(.body, weight: .medium))
            )
            .font(.plusJakartaSans(.body))
            .padding(.all, .lg)
            .multilineTextAlignment(.center)

            PinEntryView(
                isDisabled: $viewModel.isLoading,
                onPinFilled: viewModel.verifyOTP
            )

            resendButton()
        }
        .alert(
            "Error",
            isPresented: Binding(
                get: { viewModel.error != nil },
                set: { if !$0 { viewModel.error = nil } }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            if let error = viewModel.error {
                Text(error.localizedDescription)
            }
        }
    }

    private func resendButton() -> some View {
        let isDisabled = viewModel.resendCooldown > 0 || viewModel.isLoading

        return Button(action: viewModel.resendCode) {
            HStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(.white)
                } else {
                    Text(viewModel.resendCooldown > 0 ? "Resend code in \(viewModel.resendCooldown)s" : "Resend code")
                        .font(.plusJakartaSans(.body, weight: .semibold))
                }
            }
            .padding(.horizontal, .lg)
            .padding(.vertical, .md)
            .background(
                RoundedRectangle(cornerSize: .sm)
                    .foregroundStyle(
                        Color.tint.opacity(isDisabled ? 0.5 : 1)
                    )
            )
            .foregroundStyle(
                Color.white.opacity(isDisabled ? 0.5 : 1)
            )
        }
        .disabled(isDisabled)
    }
}

#if DEBUG
    import Core
    import Dependencies

    #Preview {
        OTPView(
            viewModel: OTPViewModel(
                authentication: Dependencies().authentication,
                coordinator: NavigationCoordinator(),
                signupEmail: "example@email.com"
            )
        )
    }
#endif
