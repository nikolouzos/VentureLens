import Networking
import SwiftUI

struct IdeaDetailView: View {
    let idea: Idea
    @State private var isBookmarked: Bool

    init(idea: Idea) {
        self.idea = idea
        _isBookmarked = State(initialValue: idea.isBookmarked ?? false)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacingSize: .lg) {
                Text(idea.title)
                    .font(.title)
                    .fontWeight(.bold)
                monetaryAnalysisView

                Text(idea.summary)
                    .font(.body)
                    .foregroundColor(Color.accentColor)

                analysisView

                if let competitors = idea.report?.competitors {
                    CompetitorAnalysisView(competitors: competitors)
                }

                HStack {
                    Spacer()
                    Text("Created: \(idea.createdAt, style: .date)")
                        .font(.caption)
                        .foregroundColor(Color.accentColor)
                }
            }
            .padding(.all, .lg)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: toggleBookmark) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                }
            }
        }
    }

    // MARK: - Subviews

    private var monetaryAnalysisView: some View {
        Group {
            if let report = idea.report {
                HStack {
                    Label(
                        "Est. Value: \(report.estimatedValue)",
                        systemImage: "arrow.up"
                    )
                    .foregroundStyle(Color.accentColor)

                    Spacer()

                    Label(
                        "Est. Cost: \(report.estimatedCost)",
                        systemImage: "arrow.down"
                    )
                    .foregroundStyle(Color.red)
                }
                .padding(.bottom, .sm)
            }
            Divider()
        }
        .font(.caption)
        .fontWeight(.medium)
    }

    private var analysisView: some View {
        Group {
            if let fullDetails = idea.fullDetails {
                Text(fullDetails)
                    .font(.body)
            } else {
                purchaseButton
            }
        }
    }

    private var purchaseButton: some View {
        Button(action: {
            // Implement purchase action
        }) {
            Text("Purchase Full Details")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
    }

    private func toggleBookmark() {
        isBookmarked.toggle()
        // Implement bookmark action (e.g., update in ViewModel)
    }
}

struct CompetitorAnalysisView: View {
    let competitors: [Competitor]

    var body: some View {
        VStack {
            Divider()

            ForEach(competitors, id: \.name) { competitor in
                Text(competitor.name)
                    .font(.title2)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
    }
}

#Preview {
    NavigationView {
        IdeaDetailView(idea: .mock)
    }
}
