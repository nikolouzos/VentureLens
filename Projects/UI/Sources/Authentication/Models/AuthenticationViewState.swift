import Foundation

public enum AuthenticationViewState: Sendable, Hashable {
    case loggedOut
    case loggedIn
    case otp(signupEmail: String)
    case signup
    case analyticsPermission
}
