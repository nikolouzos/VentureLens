import Foundation
import SwiftData

@Model
public class Bookmark {
    public var id: UUID?
    public var createdAt: Date = Date()

    public init(id: UUID?) {
        self.id = id
    }
}
