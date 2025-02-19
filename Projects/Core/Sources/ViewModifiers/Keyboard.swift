import Combine
import SwiftUI

// MARK: - KeyboardEventModifier

public struct KeyboardEventModifier: ViewModifier {
    public enum Event {
        case willShow
        case willHide
    }

    private let event: Event
    private let action: () -> Void

    init(event: Event, action: @escaping () -> Void) {
        self.event = event
        self.action = action
    }

    private static let keyboardWillShow = NotificationCenter.default.publisher(
        for: UIResponder.keyboardWillShowNotification
    )
    private static let keyboardWillHide = NotificationCenter.default.publisher(
        for: UIResponder.keyboardWillHideNotification
    )

    public func body(content: Content) -> some View {
        content
            .onReceive(selectPublisher()) { _ in
                action()
            }
    }

    private func selectPublisher() -> NotificationCenter.Publisher {
        switch event {
        case .willShow:
            return Self.keyboardWillShow
        case .willHide:
            return Self.keyboardWillHide
        }
    }
}

public extension View {
    func onKeyboardEvent(
        _ event: KeyboardEventModifier.Event,
        action: @escaping () -> Void
    ) -> some View {
        modifier(KeyboardEventModifier(event: event, action: action))
    }
}
