import SwiftUI

extension Font.TextStyle {
    var toUIFontTextStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle:
            return .largeTitle
        case .title:
            return .title1
        case .title2:
            return .title2
        case .title3:
            return .title3
        case .headline:
            return .headline
        case .subheadline:
            return .subheadline
        case .body:
            return .body
        case .callout:
            return .callout
        case .footnote:
            return .footnote
        case .caption:
            return .caption1
        case .caption2:
            return .caption2
        @unknown default:
            return .body
        }
    }
}

public extension SwiftUI.Font {
    /// Returns a SwiftUI Font for Plus Jakarta Sans that scales dynamically with the system’s text settings.
    static func plusJakartaSans(
        _ textStyle: Font.TextStyle,
        weight: Font.Weight = .regular
    ) -> Font {
        let fontName: String
        switch weight {
        case .medium:
            fontName = AppResourcesFontFamily.PlusJakartaSans.medium.name
        case .semibold:
            fontName = AppResourcesFontFamily.PlusJakartaSans.semiBold.name
        case .bold:
            fontName = AppResourcesFontFamily.PlusJakartaSans.bold.name
        default:
            fontName = AppResourcesFontFamily.PlusJakartaSans.regular.name
        }

        return Font.custom(fontName, size: textStyle.toUIFontTextStyle.size, relativeTo: textStyle)
    }
}
