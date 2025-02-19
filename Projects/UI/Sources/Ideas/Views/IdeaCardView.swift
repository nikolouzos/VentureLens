import AppResources
import Networking
import SwiftUI

struct IdeaCardView: View {
    let idea: Idea

    var body: some View {
        VStack(alignment: .leading, spacingSize: .md) {
            HStack(alignment: .top) {
                Text(idea.title)
                    .font(.headline)
                    .lineLimit(2)
                Spacer()
                CategoryBadge(category: idea.category)
            }

            Text(idea.summary)
                .font(.subheadline)
                .foregroundStyle(Color.accentColor)
                .lineLimit(3)

            if let fullDetails = idea.fullDetails, !fullDetails.isEmpty {
                Text(fullDetails)
                    .font(.caption)
                    .lineLimit(2)
                    .padding(.bottom, .xs)
            }

            if let report = idea.report {
                VStack(alignment: .leading, spacingSize: .md) {
                    HStack {
                        Label(
                            "Est. Value: \(report.estimatedValue)",
                            systemImage: "arrow.up"
                        )
                        .foregroundStyle(Color.accentColor)

                        Spacer()
                        Text(idea.createdAt, style: .date)
                            .foregroundStyle(Color.accentColor)
                    }

                    HStack {
                        Label(
                            "Est. Cost: \(report.estimatedCost)",
                            systemImage: "arrow.down"
                        )
                        .font(.caption)
                        .foregroundStyle(Color.red)
                    }
                }
                .font(.caption)
                .fontWeight(.medium)
            }
        }
        .padding(.all, .lg)
        .background(
            Color.themeSecondary
                .opacity(0.3)
                .clipShape(RoundedRectangle(cornerSize: .md))
        )
    }
}

struct CategoryBadge: View {
    let category: String

    var body: some View {
        Text(category)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.accentColor.opacity(0.1))
            .foregroundColor(.accentColor)
            .cornerRadius(8)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    IdeaCardView(idea: .mock)
}
