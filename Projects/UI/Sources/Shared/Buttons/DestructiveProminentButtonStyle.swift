import SwiftUI
import AppResources
import Core

// MARK: - Destructive Prominent Button Style

public struct DestructiveProminentButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool

    var isLoading: Bool = false
    var fullWidth: Bool = false
    var destructiveBackgroundColor: Color = .themePrimary
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
        .background(destructiveBackgroundColor)
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
    VStack(spacing: 20) {
        Button("Destructive Prominent") {
            print("Destructive Prominent tapped")
        }
        .buttonStyle(DestructiveProminentButtonStyle())
        
        Button("Destructive Prominent Loading") {
            print("Destructive Prominent tapped")
        }
        .buttonStyle(DestructiveProminentButtonStyle(isLoading: true))
        
        Button("Destructive Prominent Disabled") {
            print("Destructive Prominent tapped")
        }
        .buttonStyle(DestructiveProminentButtonStyle())
        .disabled(true)
    }
    .padding()
}
#endif 
