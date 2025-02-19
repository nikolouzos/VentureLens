import Core
import SwiftUI

public struct StepTutorialView: View {
    public struct Step {
        let image: Image
        let description: String

        public init(
            image: Image,
            description: String
        ) {
            self.image = image
            self.description = description
        }
    }

    let steps: [Step]
    let animationType: Animation
    @State var currentStep: Int

    public init(
        steps: [Step],
        animationType: Animation = .bouncy
    ) {
        self.steps = steps
        self.animationType = animationType
        _currentStep = .init(initialValue: 0)
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(
                                Array(zip(steps.indices, steps)), id: \.0
                            ) { index, step in
                                VStack(spacingSize: .lg) {
                                    step.image
                                        .resizable()
                                        .scaledToFit()

                                    Text(step.description)
                                        .fontWeight(.semibold)
                                        .font(.title2)
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.all, .xl)
                                .id(index)
                            }
                            .frame(width: geometry.size.width)
                        }
                        .gesture(
                            attachedDragGesture(scrollProxy: scrollProxy)
                        )
                    }
                    .scrollDisabled(true)
                }
                Stepper(
                    totalSteps: steps.count,
                    animationType: animationType,
                    currentStep: $currentStep
                )
            }
        }
    }

    private func attachedDragGesture(
        scrollProxy: ScrollViewProxy
    ) -> some Gesture {
        DragGesture()
            .onEnded { value in
                let direction = value.translation.width < 0 ? 1 : -1
                let nextStep = max(0, min(steps.count - 1, currentStep + direction))

                withAnimation(animationType) {
                    scrollProxy.scrollTo(nextStep, anchor: .center)
                    currentStep = nextStep
                }
            }
    }
}

struct Stepper: View {
    let totalSteps: Int
    let animationType: Animation
    @Binding var currentStep: Int

    var body: some View {
        HStack {
            ForEach(0 ..< totalSteps, id: \.self) { index in
                RoundedRectangle(cornerSize: .md)
                    .frame(
                        widthSize: index == currentStep ? .xl : .sm,
                        heightSize: .sm
                    )
                    .foregroundStyle(
                        index == currentStep
                            ? Color.gray
                            : Color.gray.opacity(0.3)
                    )
                    .padding(
                        .trailing,
                        index == (totalSteps - 1) ? 0 : Size.xs.rawValue
                    )
                    .animation(animationType, value: currentStep)
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    StepTutorialView(steps: [
        StepTutorialView.Step(
            image: Image(systemName: "scribble"),
            description: "Lorem ipsum dolor sit amet"
        ),
        StepTutorialView.Step(
            image: Image(systemName: "pencil"),
            description: "Lorem ipsum dolor sit amet"
        ),
        StepTutorialView.Step(
            image: Image(systemName: "pencil"),
            description: "Lorem ipsum dolor sit amet"
        ),
    ])
}
