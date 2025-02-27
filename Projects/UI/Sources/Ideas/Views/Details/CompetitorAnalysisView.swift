import Core
import Networking
import SwiftUI

/// A view that displays competitor analysis information for an idea
struct CompetitorAnalysisView: View {
    let competitors: [Competitor]
    
    var body: some View {
        VStack(alignment: .leading, spacingSize: .md) {
            SectionHeaderView(title: "Competitor Analysis")
            
            if competitors.isEmpty {
                Text("No competitor information available")
                    .font(.body)
                    .foregroundStyle(Color.themeSecondary)
            } else {
                ForEach(competitors, id: \.name) { competitor in
                    competitorCard(competitor)
                }
            }
        }
        .padding(.vertical, .md)
    }
    
    private func competitorCard(_ competitor: Competitor) -> some View {
        VStack(alignment: .leading, spacingSize: .sm) {
            Text(competitor.name)
                .font(.title3)
                .fontWeight(.semibold)
            
            if let weakness = competitor.weakness {
                HStack(alignment: .top, spacingSize: .sm) {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundStyle(Color.orange)
                    
                    Text("Weakness: \(weakness)")
                        .font(.subheadline)
                }
            }
            
            if let differentiator = competitor.differentiator {
                HStack(alignment: .top, spacingSize: .sm) {
                    Image(systemName: "checkmark.circle")
                        .foregroundStyle(Color.green)
                    
                    Text("Your Advantage: \(differentiator)")
                        .font(.subheadline)
                }
            }
        }
        .padding(.all, .md)
        .background(
            RoundedRectangle(cornerRadius: Size.md.rawValue)
                .fill(Color.secondary.opacity(0.1))
        )
    }
}

#Preview {
    CompetitorAnalysisView(competitors: [
        Competitor(
            name: "Competitor A",
            weakness: "Outdated technology stack",
            differentiator: "AI-powered recommendations"
        ),
        Competitor(
            name: "Competitor B",
            weakness: "Limited market reach",
            differentiator: "Global scalability from day one"
        )
    ])
    .padding()
} 
