import AppResources
import Core
import Networking
import SwiftUI

/// A card view that displays a summary of an idea
struct IdeaCardView: View {
    let idea: Idea

    var body: some View {
        VStack(alignment: .leading, spacingSize: .md) {
            // Header with image and title
            IdeaProse(idea: idea)
            
            VStack(alignment: .leading, spacingSize: .md) {
                // Summary and details
                IdeaCardSummaryView(
                    summary: idea.summary,
                    fullDetails: idea.fullDetails
                )

                // Financial metrics
                if let report = idea.report {
                    IdeaCardMetricsView(
                        report: report,
                        createdAt: idea.createdAt
                    )
                }
            }
            .padding(.all, .lg)
        }
        .background(
            Color(UIColor.systemBackground)
        )
        .clipShape(RoundedRectangle(cornerSize: .md))
        .shadow(
            color: Color.gray.opacity(0.2),
            radius: Size.sm.rawValue
        )
        .padding(.all, .lg)
    }
}

#if DEBUG
#Preview {
    IdeaCardView(idea: .mock)
}
#endif
