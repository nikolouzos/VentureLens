import AppResources
import Core
import SwiftUI

// MARK: - Text Button Style

public struct TextButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool

    var tintColor: Color = .tint
    var disabledColor: Color = .gray
    var font: Font = .plusJakartaSans(.body, weight: .semibold)
    var pressedScale: CGFloat = 0.95

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(font)
            .foregroundColor(
                isEnabled ?
                    (
                        configuration.isPressed
                            ? tintColor.opacity(0.7)
                            : tintColor
                    )
                    : disabledColor
            )
            .scaleEffect(configuration.isPressed ? pressedScale : 1.0)
            .animation(
                .easeOut(duration: 0.15),
                value: configuration.isPressed
            )
            .opacity(isEnabled ? 1.0 : 0.5)
    }
}

#if DEBUG
    #Preview {
        VStack(spacingSize: .lg) {
            Button("Text Button") {
                print("Text tapped")
            }
            .buttonStyle(TextButtonStyle())

            Button("Text Button Red") {
                print("Text Red tapped")
            }
            .buttonStyle(TextButtonStyle(tintColor: .red))

            Button("Text Button Disabled") {
                print("Text disabled tapped")
            }
            .buttonStyle(TextButtonStyle())
            .disabled(true)
        }
        .padding()
    }
#endif
