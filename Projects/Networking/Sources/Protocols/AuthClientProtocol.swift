import Foundation

public protocol AuthClientProtocol {
    var session: Session? { get async }

    func signInWithOTP(email: String) async throws

    func signInWithIdToken(credentials: OpenIDConnectCredentials) async throws -> Session

    func verifyOTP(email: String, token: String) async throws

    func signOut() async throws

    func refreshSession() async throws

    func update(userAttributes: UserAttributes) async throws
}
