import Foundation
import SwiftData

@Model
public final class Bookmark: Sendable {
    public var id: UUID?
    public var createdAt: Date = Date()

    public init(id: UUID?) {
        self.id = id
    }
}
