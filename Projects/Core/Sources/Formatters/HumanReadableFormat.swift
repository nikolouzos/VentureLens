import Foundation

public struct HumanReadableFormat: FormatStyle {
    public func format(_ value: Int) -> String {
        let thousand = 1_000
        let million = 1_000_000
        let billion = 1_000_000_000

        switch value {
        case 0..<thousand:
            return "\(value)"
            
        case thousand..<million:
            return "\(value / thousand)K"
            
        case million..<billion:
            return "\(value / million)M"
            
        default:
            return "\(value / billion)B"
        }
    }
}

public extension FormatStyle where Self == HumanReadableFormat {
    static var humanReadable: HumanReadableFormat {
        HumanReadableFormat()
    }
}
