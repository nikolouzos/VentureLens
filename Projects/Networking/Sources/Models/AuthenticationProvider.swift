import Foundation
import SwiftData

@Model
public final class OAuthSignupData: Sendable {
    var email: String?
    var name: String?

    public init(email: String?, name: String?) {
        self.email = email
        self.name = name
    }
}

public enum AuthenticationProvider: Equatable, Sendable {
    case anonymous
    case otp(email: String)
    case apple(
        identityToken: String,
        signupData: OAuthSignupData? = nil
    )
}
