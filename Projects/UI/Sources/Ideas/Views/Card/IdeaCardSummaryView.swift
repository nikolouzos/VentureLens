import AppResources
import Core
import SwiftUI

/// A view that displays the summary for an idea card
struct IdeaCardSummaryView: View {
    let summary: String
    let fullDetails: String?
    
    var body: some View {
        VStack(alignment: .leading, spacingSize: .md) {
            Text(summary)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color.tint)
                .lineLimit(3)

            if let fullDetails = fullDetails, !fullDetails.isEmpty {
                Text(fullDetails)
                    .font(.caption)
                    .lineLimit(3)
                    .padding(.bottom, .xs)
            }
        }
    }
}

#Preview {
    IdeaCardSummaryView(
        summary: "A revolutionary app that helps users track their daily habits and improve productivity.",
        fullDetails: "This app uses machine learning to analyze user behavior patterns and provide personalized recommendations for habit formation and productivity improvement."
    )
    .padding()
} 
