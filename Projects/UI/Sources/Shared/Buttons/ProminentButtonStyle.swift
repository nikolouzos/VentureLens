import AppResources
import Core
import SwiftUI

// MARK: - Prominent Button Style

public struct ProminentButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool

    var isLoading: Bool = false
    var fullWidth: Bool = false
    var backgroundColor: Color = .tint
    var foregroundColor: Color = .white
    var font: Font = .plusJakartaSans(.body, weight: .semibold)
    var horizontalPadding: Size = .lg
    var verticalPadding: Size = .md
    var cornerSize: CGSize = .md

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            if fullWidth { Spacer() }
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(foregroundColor)
            } else {
                configuration.label
                    .font(font)
            }
            if fullWidth { Spacer() }
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        .clipShape(RoundedRectangle(cornerSize: cornerSize))
        .opacity(isEnabled ? 1.0 : 0.5)
        .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        .animation(
            .easeOut(duration: 0.2),
            value: configuration.isPressed
        )
        .allowsHitTesting(!isLoading && isEnabled)
    }
}

#if DEBUG
    #Preview {
        VStack(spacingSize: .lg) {
            Button("Prominent Button") {
                print("Prominent tapped")
            }
            .buttonStyle(
                ProminentButtonStyle()
            )

            Button("Prominent Loading") {
                print("Prominent tapped")
            }
            .buttonStyle(
                ProminentButtonStyle(isLoading: true)
            )

            Button("Prominent Full Width") {
                print("Prominent tapped")
            }
            .buttonStyle(
                ProminentButtonStyle(fullWidth: true)
            )

            Button("Prominent Disabled") {
                print("Prominent tapped")
            }
            .buttonStyle(
                ProminentButtonStyle()
            )
            .disabled(true)
        }
        .padding()
    }
#endif
