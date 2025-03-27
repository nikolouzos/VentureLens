import Foundation

public struct OpenIDConnectCredentials {
    public let provider: Provider
    public let idToken: String
    public let accessToken: String?

    public init(provider: Provider, idToken: String, accessToken: String? = nil) {
        self.provider = provider
        self.idToken = idToken
        self.accessToken = accessToken
    }
}

public enum Provider: String, CaseIterable, Sendable {
    case apple
}
