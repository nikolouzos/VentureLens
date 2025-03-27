import Foundation

final class EnvironmentVariables: Sendable {
    private let bundle: Bundle

    static let shared = EnvironmentVariables()

    public init(bundle: Bundle = Bundle(for: EnvironmentVariables.self)) {
        self.bundle = bundle
    }

    func get(key: EnvironmentVariableKeys) -> String? {
        return bundle.object(forInfoDictionaryKey: key.rawValue) as? String
    }
}
