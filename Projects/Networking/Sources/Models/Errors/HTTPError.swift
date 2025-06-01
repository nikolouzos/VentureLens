import Foundation

public enum HTTPError: Error, Sendable {
    case common(status: Int, error: CommonError)
    case unknown
}
