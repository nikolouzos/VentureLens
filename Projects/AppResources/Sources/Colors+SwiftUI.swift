import SwiftUI

public extension SwiftUI.Color {
    // MARK: - System
    static let systemBackground = Color(uiColor: UIColor.systemBackground)
    static let systemLabel = Color(uiColor: UIColor.label)
    
    // MARK: - Theme
    static let tint = AppResourcesAsset.Colors.accentColor.swiftUIColor
    static let themePrimary = AppResourcesAsset.Colors.themePrimary.swiftUIColor
    static let themeSecondary = AppResourcesAsset.Colors.themeSecondary.swiftUIColor
}
