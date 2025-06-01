import Foundation

public struct AppMetadata {
    private let bundle: Bundle

    private enum Keys: String {
        case shortVersion = "CFBundleShortVersionString"
        case version = "CFBundleVersion"
    }

    public init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    // MARK: - Versioning

    public var version: String {
        bundle.infoDictionary?[Keys.shortVersion.rawValue] as? String ?? "1.0"
    }

    public var buildNumber: String {
        bundle.infoDictionary?[Keys.version.rawValue] as? String ?? "1"
    }

    public var versionString: String {
        "\(version) (\(buildNumber))"
    }

    // MARK: - Legal

    public let legalURLs: (termsOfService: URL, privacyPolicy: URL) = (
        termsOfService: URL(string: "https://venturelens.app/terms")!,
        privacyPolicy: URL(string: "https://venturelens.app/privacy")!
    )
}
