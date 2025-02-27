import AppResources
import Core
import Networking
import SwiftUI

/// A view that displays financial metrics for an idea card
struct IdeaCardMetricsView: View {
    let report: Report
    let createdAt: Date
    
    var body: some View {
        VStack(alignment: .leading, spacingSize: .md) {
            HStack {
                Label(
                    "Year 1 Revenue: \(formatCurrency(report.financials?.totalYear1Revenue))",
                    systemImage: "arrow.up"
                )
                .foregroundStyle(Color.green)

                Spacer()
                Text(createdAt, style: .date)
                    .foregroundStyle(Color.tint)
            }

            HStack {
                Label(
                    "Year 1 Costs: \(formatCurrency(report.financials?.totalYear1Costs))",
                    systemImage: "arrow.down"
                )
                .foregroundStyle(Color.themePrimary)
            }
        }
        .font(.caption)
        .fontWeight(.medium)
    }
    
    private func formatCurrency(_ value: Int?) -> String {
        guard let value else {
            return "-"
        }
        return NumberFormatter.usdCurrency.string(from: value) ?? "$\(value)"
    }
}

#Preview {
    IdeaCardMetricsView(
        report: Report(
            competitors: nil,
            financials: Financials(
                totalYear1Costs: 500000,
                totalYear1Revenue: 1200000,
                startupCosts: nil,
                projections: nil,
                fundingAdvice: nil,
                unitEconomics: nil
            ),
            market: nil,
            roadmap: nil
        ),
        createdAt: Date()
    )
    .padding()
} 
