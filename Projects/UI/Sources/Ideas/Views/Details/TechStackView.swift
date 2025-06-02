import Core
import Networking
import SwiftUI

/// A view that displays tech stack information for an idea
struct TechStackView: View {
    let techStack: [TechStackComponent]?

    var body: some View {
        VStack(alignment: .leading, spacingSize: .md) {
            SectionHeaderView(title: "Technology Stack")

            if let techStack = techStack, !techStack.isEmpty {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                    ],
                    spacingSize: .md
                ) {
                    ForEach(techStack.indices, id: \.self) { index in
                        let component = techStack[index]
                        techStackCard(component)
                    }
                }
            } else {
                Text("No tech stack information available")
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding(.vertical, .md)
    }

    private func techStackCard(_ component: TechStackComponent) -> some View {
        VStack(alignment: .leading, spacingSize: .sm) {
            if let componentName = component.component {
                Text(componentName)
                    .font(.plusJakartaSans(.title3, weight: .semibold))
                    .foregroundStyle(Color.tint)
            }

            Spacer()

            if let tools = component.tools, !tools.isEmpty {
                VStack(alignment: .leading, spacingSize: .xs) {
                    Text("Recommended Tools:")
                        .font(.plusJakartaSans(.caption))
                        .foregroundStyle(Color.secondary)
                        .padding(.bottom, .xs)

                    ForEach(tools, id: \.self) { tool in
                        HStack(spacingSize: .xs) {
                            Image(systemName: "wrench.and.screwdriver")
                                .foregroundStyle(Color.secondary)

                            Text(tool)
                        }
                        .font(.plusJakartaSans(.callout))
                    }
                }
                Spacer()
            }
        }
        .padding(.all, .md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerSize: .md)
                .fill(Color.secondary.opacity(0.1))
        )
    }
}

#Preview {
    TechStackView(techStack: [
        TechStackComponent(
            component: "Frontend",
            tools: ["SwiftUI", "UIKit", "Combine"]
        ),
        TechStackComponent(
            component: "Backend",
            tools: ["Node.js", "Express", "MongoDB"]
        ),
        TechStackComponent(
            component: "DevOps",
            tools: ["Docker", "AWS", "CI/CD"]
        ),
        TechStackComponent(
            component: "Analytics",
            tools: ["Firebase Analytics", "Mixpanel", "Amplitude"]
        ),
    ])
    .padding()
}
