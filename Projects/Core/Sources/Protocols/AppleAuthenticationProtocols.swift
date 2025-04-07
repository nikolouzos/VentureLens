import AuthenticationServices
import Foundation

/// Protocol defining the requirements for Apple ID authorization requests
public protocol AppleIDRequestProtocol: AnyObject {
    /// The requested scopes for the Apple ID authorization
    var requestedScopes: [ASAuthorization.Scope]? { get set }
}

/// Protocol defining the requirements for Apple authorization
public protocol AppleAuthorizationProtocol {
    /// The credential obtained from the authorization
    var credential: ASAuthorizationCredential { get }
}

/// Protocol defining the requirements for Apple ID credentials
public protocol AppleIDCredentialProtocol {
    /// The identity token data obtained from authentication
    var identityToken: Data? { get }
    
    /// The email address provided from authentication
    var email: String? { get }
    
    /// The user's full name provided from authentication
    var fullName: PersonNameComponents? { get }
}
