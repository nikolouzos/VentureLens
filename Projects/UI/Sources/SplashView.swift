import AppResources
import SwiftUI

public struct SplashView: View {
    @Binding private var hasFinishedLaunching: Bool
    let animationDuration: Double

    public init(
        hasFinishedLaunching: Binding<Bool>,
        animationDuration: Double
    ) {
        _hasFinishedLaunching = hasFinishedLaunching
        self.animationDuration = animationDuration
    }

    public var body: some View {
        VStack(alignment: .center, spacingSize: .xl) {
            Text("VentureLens")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color.tint)
                .multilineTextAlignment(.center)

            AppearTransitionView(
                transition: .opacity,
                duration: 0.5
            ) {
                AppResourcesAsset.Assets.logo.swiftUIImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(
                        hasFinishedLaunching ? 4.0 : 1.0,
                        anchor: .init(x: 0.45, y: 0.3)
                    )
                    .animation(.easeIn(duration: animationDuration), value: hasFinishedLaunching)
                    .zIndex(1)
            }

            if !hasFinishedLaunching {
                ProgressView()
                    .transaction { $0.animation = .none }
            }
        }
        .onDisappear {
            hasFinishedLaunching = false
        }
    }
}

#if DEBUG
    #Preview {
        @Previewable @State var hasFinishedLaunching = false
        return SplashView(
            hasFinishedLaunching: $hasFinishedLaunching,
            animationDuration: 0.5
        )
        .task {
            try? await Task.sleep(for: .seconds(1))
            hasFinishedLaunching = true
        }
    }
#endif
