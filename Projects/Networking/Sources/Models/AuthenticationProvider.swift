import Foundation

public struct OAuthSignupData {
    let email: String
    let name: String
}

public enum AuthenticationProvider {
    case otp(email: String)
    case apple(
        identityToken: String,
        signupData: OAuthSignupData? = nil
    )
    case google(
        identityToken: String,
        accessToken: String,
        signupData: OAuthSignupData? = nil
    )
}
