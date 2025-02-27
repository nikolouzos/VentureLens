import Core
import SwiftUI

/// A reusable view for section headers
struct SectionHeaderView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.bold)
            .padding(.bottom, .xs)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VStack {
        SectionHeaderView(title: "Financial Analysis")
        SectionHeaderView(title: "Market Analysis")
        SectionHeaderView(title: "Competitor Analysis")
    }
    .padding()
} 