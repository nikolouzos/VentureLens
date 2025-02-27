import Combine
import SwiftUI

public struct OTPView: View {
    @StateObject var viewModel: OTPViewModel
    @FocusState private var focusedField: Int?

    public init(viewModel: OTPViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(alignment: .center) {
            (
                Text("Please enter the One-Time Password you received on ") +
                    Text(viewModel.signupEmail)
                    .fontWeight(.medium)
            )
            .padding(.all, .lg)
            .multilineTextAlignment(.center)
            PinEntryView(
                isDisabled: $viewModel.isLoading,
                onPinFilled: viewModel.verifyOTP
            )
        }
    }
}

#if DEBUG
    import Core
    import Networking

    #Preview {
        OTPView(
            viewModel: OTPViewModel(
                authentication: MockAuthentication(),
                coordinator: NavigationCoordinator<AuthenticationViewState>(),
                signupEmail: "example@email.com"
            )
        )
    }
#endif
