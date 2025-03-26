import UIKit

@MainActor
public protocol URLOpener {
    /// Checks if the application can open the specified URL
    /// - Parameter url: The URL to check
    /// - Returns: A boolean indicating if the URL can be opened
    func canOpenURL(_ url: URL) -> Bool

    /// Opens the specified URL
    /// - Parameter url: The URL to open
    /// - Parameter options: The options to use when opening the URL
    /// - Returns: A boolean indicating if the URL was opened successfully
    @discardableResult
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any]) async -> Bool
}

extension URLOpener {
    @discardableResult
    func open(_ url: URL) async -> Bool {
        await open(url, options: [:])
    }
}
