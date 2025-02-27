import Foundation
import SwiftData

@Model
public class OAuthSignupData {
    var email: String?
    var name: String?
    
    public init(email: String, name: String) {
        self.email = email
        self.name = name
    }
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
