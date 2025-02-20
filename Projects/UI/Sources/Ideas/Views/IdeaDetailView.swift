import Core
import Networking
import SwiftUI

struct IdeaDetailView: View {
    @Environment(\.dismiss) var dismiss
    let idea: Idea
    @State private var isBookmarked: Bool

    init(idea: Idea) {
        self.idea = idea
        _isBookmarked = State(initialValue: idea.isBookmarked ?? false)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacingSize: .lg) {
                ZStack(alignment: .top) {
                    CardProse(idea: idea)
                    
                    HStack {
                        Circle()
                            .fill(Color.gray.opacity(0.5))
                            .overlay {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.all, 10)
                            }
                            .frame(widthSize: .xl, heightSize: .xl)
                            .onTapGesture { dismiss() }
                        
                        Spacer()
                        
                        Button(action: toggleBookmark) {
                            Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(widthSize: .lg)
                        }
                    }
                    .padding(.all, .lg)
                }
                .ignoresSafeArea(edges: [.top])
                
                VStack(alignment: .leading, spacingSize: .lg) {
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
//            if let fullDetails = idea.fullDetails {
//                Text(fullDetails)
//                    .font(.body)
//            } else {
                purchaseBanner
//            }
    }

    private var purchaseBanner: some View {
        // TODO: Make this look nice
        VStack(alignment: .center, spacingSize: .lg) {
            Text("This idea contains premium content. Purchase to unlock full access.")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            Button("Purchase Now", systemImage: "creditcard.fill") {
                print("Purchase action")
            }
            .buttonStyle(.borderedProminent)
        }
        .font(.headline)
        .padding(.all, .lg)
        .background(
            Color.themeSecondary
                .clipShape(
                    RoundedRectangle(cornerSize: .md)
                )
        )
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

import AppResources

#Preview {
    NavigationView {
        IdeaDetailView(idea: .mock)
    }
}
