import UIKit

extension UIFont.TextStyle {
    /// Returns the current preferred point size for the text style.
    var size: CGFloat {
        UIFont.preferredFont(forTextStyle: self).pointSize
    }
}

public extension UIKit.UIFont {
    /// Returns a dynamically scaled Plus Jakarta Sans font for a given text style and weight.
    static func plusJakartaSans(
        _ textStyle: UIFont.TextStyle,
        weight: UIFont.Weight = .regular
    ) -> UIFont {
        let font: AppResourcesFontConvertible
        switch weight {
        case .medium:
            font = AppResourcesFontFamily.PlusJakartaSans.medium
        case .semibold:
            font = AppResourcesFontFamily.PlusJakartaSans.semiBold
        case .bold:
            font = AppResourcesFontFamily.PlusJakartaSans.bold
        default:
            font = AppResourcesFontFamily.PlusJakartaSans.regular
        }

        // Create the base font at the preferred size and scale it according to Dynamic Type.
        let baseFont = font.font(size: textStyle.size)
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: baseFont)
    }
}
