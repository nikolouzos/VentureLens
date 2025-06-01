import CoreFoundation

public enum Size: Sendable, RawRepresentable {
    public typealias RawValue = CGFloat

    // MARK: - Cases

    /// 0 points
    case zero

    /// 4 points
    case xs

    /// 8 points
    case sm

    /// 12 points
    case md

    /// 16 points
    case lg

    /// 32 points
    case xl

    /// 64 points
    case xxl

    /// Internal - Use only via .composite(_:, _:)
    case custom(CGFloat)

    // MARK: - Init

    public init?(rawValue: CGFloat) {
        switch rawValue {
        case 0: self = .zero
        case 4: self = .xs
        case 8: self = .sm
        case 12: self = .md
        case 16: self = .lg
        case 32: self = .xl
        case 64: self = .xxl
        default: return nil
        }
    }

    // MARK: - Raw Values

    public var rawValue: CGFloat {
        switch self {
        case .zero: 0
        case .xs: 4
        case .sm: 8
        case .md: 12
        case .lg: 16
        case .xl: 32
        case .xxl: 64
        case let .custom(f): f
        }
    }
}

// MARK: - Composite Size

public extension Size {
    static func composite(_ first: Size, _ second: Size) -> Size {
        custom(first.rawValue + second.rawValue)
    }
}
