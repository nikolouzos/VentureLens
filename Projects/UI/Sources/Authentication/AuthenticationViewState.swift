import Foundation

public enum AuthenticationViewState: Hashable {
    case loggedOut
    case loggedIn
    case otp(signupEmail: String)
    case signup
}
