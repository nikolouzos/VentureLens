import AuthenticationServices
import Core

extension ASAuthorizationAppleIDRequest: @retroactive AppleIDRequestProtocol {}
extension ASAuthorization: @retroactive AppleAuthorizationProtocol {}
extension ASAuthorizationAppleIDCredential: @retroactive AppleIDCredentialProtocol {}
