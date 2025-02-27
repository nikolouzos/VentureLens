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
                        GridItem(.flexible())
                    ],
                    spacing: Size.md.rawValue
                ) {
                    ForEach(techStack.indices, id: \.self) { index in
                        let component = techStack[index]
                        techStackCard(component)
                    }
                }
            } else {
                Text("No tech stack information available")
                    .font(.body)
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding(.vertical, .md)
    }
    
    private func techStackCard(_ component: TechStackComponent) -> some View {
        VStack(alignment: .leading, spacingSize: .sm) {
            if let componentName = component.component {
                Text(componentName)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.themePrimary)
            }
            
            if let tools = component.tools, !tools.isEmpty {
                VStack(alignment: .leading, spacingSize: .xs) {
                    Text("Recommended Tools:")
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                    
                    Spacer()
                    
                    ForEach(tools, id: \.self) { tool in
                        HStack(spacingSize: .xs) {
                            Image(systemName: "wrench.and.screwdriver")
                                .foregroundStyle(Color.secondary)
                            
                            Text(tool)
                                .font(.callout)
                        }
                    }
                }
            }
        }
        .padding(.all, .md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Size.md.rawValue)
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
        )
    ])
    .padding()
} 
