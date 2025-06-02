import AppResources
import Core
import SwiftUI

// MARK: - Outline Button Style

public struct OutlineButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool

    var fullWidth: Bool = false
    var tintColor: Color = .tint
    var font: Font = .plusJakartaSans(.body, weight: .semibold)
    var horizontalPadding: Size = .lg
    var verticalPadding: Size = .md
    var cornerSize: CGSize = .md
    var lineWidth: CGFloat = 1

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            if fullWidth { Spacer() }
            configuration.label
                .font(font)
            if fullWidth { Spacer() }
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .foregroundColor(isEnabled ? tintColor : Color.gray)
        .background(
            RoundedRectangle(cornerSize: cornerSize)
                .stroke(
                    isEnabled
                        ? tintColor
                        : Color.gray,
                    lineWidth: lineWidth
                )
        )
        .opacity(isEnabled ? 1.0 : 0.5)
        .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        .animation(
            .easeOut(duration: 0.2),
            value: configuration.isPressed
        )
    }
}

#if DEBUG
    #Preview {
        VStack(spacingSize: .lg) {
            Button("Outline Button") {
                print("Outline tapped")
            }
            .buttonStyle(OutlineButtonStyle())

            Button("Outline Full Width") {
                print("Outline tapped")
            }
            .buttonStyle(OutlineButtonStyle(fullWidth: true))

            Button("Outline Disabled") {
                print("Outline tapped")
            }
            .buttonStyle(OutlineButtonStyle())
            .disabled(true)
        }
        .padding()
    }
#endif
