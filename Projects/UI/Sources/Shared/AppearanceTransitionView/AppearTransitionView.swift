import SwiftUI

/// A view that handles appear/disappear transitions based on a predicate or view appearance
struct AppearTransitionView<Content: View>: View {
    /// Optional predicate to control transitions
    private var predicate: Binding<Bool>?

    /// Duration of the transition animation
    private let duration: Double

    /// Delay before starting the transition
    private let delay: Double

    /// The custom transition to use
    private let transition: AnyTransition

    /// The content to be displayed
    @ViewBuilder private let content: () -> Content

    /// View's opacity state
    @State private var isVisible: Bool = false

    var body: some View {
        HStack {
            if isVisible {
                content()
                    .transition(transition)
            }
        }
        .onAppear {
            // If predicate is nil, trigger transition immediately
            if predicate == nil {
                animateIn()
            }
        }
        .onReceive(predicate.publisher) { newValue in
            // Trigger transition based on predicate value
            if newValue.wrappedValue {
                animateIn()
            } else {
                animateOut()
            }
        }
    }

    /// Animates the view in
    private func animateIn() {
        withAnimation(.easeOut(duration: duration).delay(delay)) {
            isVisible = true
        }
    }

    /// Animates the view out
    private func animateOut() {
        withAnimation(.easeIn(duration: duration).delay(delay)) {
            isVisible = false
        }
    }
}

// MARK: - Convenience Initializers

extension AppearTransitionView {
    /// Initializer for predicate-based transitions
    init(
        if predicate: Binding<Bool>?,
        transition: AnyTransition,
        duration: Double = 0.3,
        delay: Double = 0,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.predicate = predicate
        self.transition = transition
        self.duration = duration
        self.delay = delay
        self.content = content
    }

    /// Initializer for appearance-based transitions
    init(
        transition: AnyTransition,
        duration: Double = 0.3,
        delay: Double = 0,
        @ViewBuilder content: @escaping () -> Content
    ) {
        predicate = nil
        self.transition = transition
        self.duration = duration
        self.delay = delay
        self.content = content
    }
}

// MARK: - Preview Provider

#Preview {
    @Previewable @State var showSlide = false

    VStack(spacingSize: .lg) {
        // Appearance-based transition
        AppearTransitionView(
            transition: .offset(y: 20).combined(with: .opacity),
            delay: 0.3
        ) {
            Text("Appears with offset + fade")
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
        }

        // Predicate-based transition
        AppearTransitionView(
            if: $showSlide,
            transition: .slide,
            duration: 0.5
        ) {
            Text("Appears with slide")
                .padding()
                .background(Color.green)
                .cornerRadius(8)
        }

        Button("\(showSlide ? "Hide" : "Show") sliding button") {
            showSlide.toggle()
        }
    }
}
