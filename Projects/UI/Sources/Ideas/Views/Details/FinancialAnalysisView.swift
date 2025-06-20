import Charts
import Core
import Networking
import SwiftUI

/// A view that displays financial analysis information for an idea
struct FinancialAnalysisView: View {
    let financials: Financials?

    var body: some View {
        VStack(alignment: .leading, spacingSize: .md) {
            SectionHeaderView(title: "Financial Analysis")

            if let financials = financials {
                // Summary metrics
                summaryMetricsView(financials)

                // Projections chart
                if let projections = financials.projections {
                    projectionChartView(projections)
                }

                // Startup costs breakdown
                if let startupCosts = financials.startupCosts {
                    startupCostsView(startupCosts)
                }

                // Unit economics
                if let unitEconomics = financials.unitEconomics {
                    unitEconomicsView(unitEconomics)
                }

                // Funding advice
                if let fundingAdvice = financials.fundingAdvice, !fundingAdvice.isEmpty {
                    fundingAdviceView(fundingAdvice)
                }
            } else {
                Text("No financial information available")
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding(.vertical, .md)
    }

    private func summaryMetricsView(_ financials: Financials) -> some View {
        HStack {
            if let totalYear1Revenue = financials.totalYear1Revenue {
                metricCard(
                    title: "Year 1 Revenue",
                    value: formatCurrency(totalYear1Revenue),
                    systemImage: "arrow.up.right",
                    color: .green
                )
            }

            if let totalYear1Costs = financials.totalYear1Costs {
                metricCard(
                    title: "Year 1 Costs",
                    value: formatCurrency(totalYear1Costs),
                    systemImage: "arrow.down.right",
                    color: Color.themePrimary
                )
            }
        }
    }

    private func metricCard(title: String, value: String, systemImage: String, color: Color) -> some View {
        VStack(alignment: .leading, spacingSize: .xs) {
            Text(title)
                .font(.plusJakartaSans(.caption))
                .foregroundStyle(Color.secondary)

            HStack(spacingSize: .xs) {
                Image(systemName: systemImage)
                    .foregroundStyle(color)

                Text(value)
                    .font(.plusJakartaSans(.headline))
                    .foregroundStyle(color)
            }
        }
        .padding(.all, .md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerSize: .md)
                .fill(Color.secondary.opacity(0.1))
        )
    }

    @ViewBuilder
    private func projectionChartView(_ projections: Projections) -> some View {
        VStack(alignment: .leading, spacingSize: .sm) {
            Text("Revenue Projections")
                .font(.plusJakartaSans(.subheadline, weight: .medium))

            Chart {
                if let year1 = projections.year1 {
                    BarMark(
                        x: .value("Year", "Year 1"),
                        y: .value("Revenue", year1)
                    )
                }

                if let year2 = projections.year2 {
                    BarMark(
                        x: .value("Year", "Year 2"),
                        y: .value("Revenue", year2)
                    )
                }

                if let year3 = projections.year3 {
                    BarMark(
                        x: .value("Year", "Year 3"),
                        y: .value("Revenue", year3)
                    )
                }
            }
            .foregroundStyle(Color.themeSecondary)
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(format: .humanReadable)
            }
        }
        .padding(.all, .md)
        .background(
            RoundedRectangle(cornerSize: .md)
                .fill(Color.secondary.opacity(0.1))
        )
    }

    private func startupCostsView(_ costs: StartupCosts) -> some View {
        VStack(alignment: .leading, spacingSize: .sm) {
            Text("Startup Costs Breakdown")
                .font(.plusJakartaSans(.subheadline, weight: .medium))

            HStack(spacingSize: .md) {
                if let development = costs.development {
                    costItem(label: "Development", value: formatCurrency(development))
                }

                if let marketing = costs.marketing {
                    costItem(label: "Marketing", value: formatCurrency(marketing))
                }

                if let compliance = costs.compliance {
                    costItem(label: "Compliance", value: formatCurrency(compliance))
                }
            }
        }
        .padding(.all, .md)
        .background(
            RoundedRectangle(cornerSize: .md)
                .fill(Color.secondary.opacity(0.1))
        )
    }

    private func costItem(label: String, value: String) -> some View {
        VStack(alignment: .center, spacingSize: .xs) {
            Text(label)
                .font(.plusJakartaSans(.caption))
                .foregroundStyle(Color.secondary)

            Text(value)
                .font(.plusJakartaSans(.subheadline, weight: .medium))
        }
        .frame(maxWidth: .infinity)
    }

    private func unitEconomicsView(_ economics: UnitEconomics) -> some View {
        VStack(alignment: .leading, spacingSize: .sm) {
            Text("Unit Economics")
                .font(.plusJakartaSans(.subheadline, weight: .medium))

            HStack(spacingSize: .md) {
                if let cac = economics.cac {
                    economicMetric(label: "CAC", value: formatCurrency(cac))
                }

                if let ltv = economics.ltv {
                    economicMetric(label: "LTV", value: formatCurrency(ltv))
                }

                if let payback = economics.paybackPeriodMonths {
                    economicMetric(label: "Payback Period", value: "\(payback) months")
                }
            }
        }
        .padding(.all, .md)
        .background(
            RoundedRectangle(cornerSize: .md)
                .fill(Color.secondary.opacity(0.1))
        )
    }

    private func economicMetric(label: String, value: String) -> some View {
        VStack(alignment: .center, spacingSize: .xs) {
            Text(label)
                .font(.plusJakartaSans(.caption))
                .foregroundStyle(Color.secondary)

            Text(value)
                .font(.plusJakartaSans(.subheadline, weight: .medium))
        }
        .frame(maxWidth: .infinity)
    }

    private func fundingAdviceView(_ advice: [String]) -> some View {
        VStack(alignment: .leading, spacingSize: .sm) {
            Text("Funding Advice")
                .font(.plusJakartaSans(.subheadline, weight: .medium))

            ForEach(advice, id: \.self) { item in
                HStack(alignment: .center, spacingSize: .sm) {
                    Image(systemName: "lightbulb")
                        .foregroundStyle(Color.green)

                    Text(item)
                        .multilineTextAlignment(.leading)
                }
                .font(.plusJakartaSans(.callout))
            }
        }
        .padding(.all, .md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerSize: .md)
                .fill(Color.secondary.opacity(0.1))
        )
    }

    private func formatCurrency(_ value: Int) -> String {
        return NumberFormatter.usdCurrency.string(from: value) ?? "$\(value)"
    }
}

#Preview {
    FinancialAnalysisView(financials: Financials(
        totalYear1Costs: 500_000,
        totalYear1Revenue: 1_200_000,
        startupCosts: StartupCosts(
            development: 300_000,
            marketing: 150_000,
            compliance: 50000
        ),
        projections: Projections(
            year1: 1_200_000,
            year2: 3_500_000,
            year3: 7_800_000
        ),
        fundingAdvice: [
            "Seek seed funding of at least $750K",
            "Consider strategic partnerships with established players",
            "Prepare for Series A within 18 months of launch",
        ],
        unitEconomics: UnitEconomics(
            cac: 120,
            ltv: 840,
            paybackPeriodMonths: 6
        )
    ))
    .padding()
}
