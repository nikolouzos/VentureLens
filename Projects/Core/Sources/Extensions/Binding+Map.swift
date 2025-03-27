import SwiftUICore

public extension Binding where Value == Sendable {
    func map<U>(_ transform: @Sendable @escaping (Value) -> U) -> Binding<U> {
        .init(
            get: { transform(self.wrappedValue) },
            set: { _ in }
        )
    }
    
    func map<U>(_ transform: @Sendable @escaping (Optional<Value>) -> U) -> Binding<U> {
        .init(
            get: { transform(self.wrappedValue) },
            set: { _ in }
        )
    }
}
