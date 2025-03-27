import Foundation

public enum AuthenticationViewState: Hashable, Sendable {
    case loggedOut
    case loggedIn
    case otp(signupEmail: String)
    case signup
    case analyticsPermission
}
