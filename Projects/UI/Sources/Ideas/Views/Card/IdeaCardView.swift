import Core
import Networking
import SwiftUI

/// A card view that displays a summary of an idea
struct IdeaCardView: View {
    let idea: Idea
    var currentUser: User?

    private var shouldShowUnlockedIcon: Bool {
        guard let user = currentUser else { return false }
        return user.subscription == .free && user.unlockedIdeas.contains(idea.id)
    }

    var body: some View {
        VStack(alignment: .leading, spacingSize: .zero) {
            // Idea Header
            ZStack(alignment: .topLeading) {
                IdeaProse(idea: idea)
                ideaUnlockedIcon
            }

            VStack(alignment: .leading, spacingSize: .md) {
                // Summary and details
                IdeaCardSummaryView(
                    summary: idea.summary
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

    @ViewBuilder
    private var ideaUnlockedIcon: some View {
        if shouldShowUnlockedIcon {
            Image(systemName: "lock.open.fill")
                .font(.headline)
                .padding(.all, .sm)
                .background(
                    Material.thickMaterial,
                    in: Circle()
                )
                .padding(.all, .md)
        }
    }
}

#if DEBUG
    #Preview {
        IdeaCardView(idea: .mock)
    }

    #Preview("With Unlocked Icon") {
        let idea = Idea.mock

        IdeaCardView(
            idea: idea,
            currentUser: User(
                id: UUID(),
                email: "test@example.com",
                name: "Test User",
                subscription: .free,
                unlockedIdeas: [idea.id]
            )
        )
    }
#endif
