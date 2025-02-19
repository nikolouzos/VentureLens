import os
import SwiftUI

struct LoggerEnvironmentKey: EnvironmentKey {
    static let defaultValue = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "",
        category: "default"
    )
}

public extension EnvironmentValues {
    var logger: Logger {
        get { self[LoggerEnvironmentKey.self] }
        set { self[LoggerEnvironmentKey.self] = newValue }
    }
}
