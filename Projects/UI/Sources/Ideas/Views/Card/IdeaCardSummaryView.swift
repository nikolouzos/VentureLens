import AppResources
import Core
import SwiftUI

/// A view that displays the summary for an idea card
struct IdeaCardSummaryView: View {
    let summary: String

    var body: some View {
        Text(summary)
            .font(.plusJakartaSans(.subheadline, weight: .medium))
            .foregroundStyle(Color.systemLabel)
            .lineLimit(4)
    }
}

#Preview {
    IdeaCardSummaryView(
        summary: "A revolutionary app that helps users track their daily habits and improve productivity."
    )
    .padding()
}
