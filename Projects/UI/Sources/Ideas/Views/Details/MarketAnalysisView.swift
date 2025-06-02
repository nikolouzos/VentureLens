import AppResources
import Charts
import Core
import Networking
import SwiftUI

/// A view that displays market analysis information for an idea
struct MarketAnalysisView: View {
    let market: Market?
    let competitors: [Competitor]?

    var body: some View {
        VStack(alignment: .leading, spacingSize: .md) {
            SectionHeaderView(title: "Market Analysis")

            if let market = market {
                // TAM (Total Addressable Market)
                if let tam = market.tam {
                    tamView(tam)
                }

                // Growth Rate
                if let growthRate = market.growthRate {
                    growthRateView(growthRate)
                }

                // Demographics
                if let demographics = market.demographics, !demographics.isEmpty {
                    demographicsView(demographics)
                }

                // Competitor Analysis
                if let competitors {
                    CompetitorAnalysisView(
                        competitors: competitors
                    )
                }
            } else {
                Text("No market information available")
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding(.vertical, .md)
    }

    private func tamView(_ tam: TAM) -> some View {
        VStack(alignment: .leading, spacingSize: .sm) {
            HStack {
                Text("Total Addressable Market")
                    .font(.plusJakartaSans(.subheadline, weight: .medium))

                Spacer()

                if let value = tam.value {
                    Text(formatCurrency(value))
                        .font(.plusJakartaSans(.title3, weight: .bold))
                        .foregroundStyle(Color.tint)
                }
            }

            if let segments = tam.segments {
                tamSegmentsView(segments)
            }
        }
        .padding(.all, .md)
        .background(
            RoundedRectangle(cornerSize: .md)
                .fill(Color.secondary.opacity(0.1))
        )
    }

    @ViewBuilder
    private func tamSegmentsView(_ segments: Segments) -> some View {
        VStack(alignment: .leading, spacingSize: .sm) {
            if let geography = segments.geography, !geography.isEmpty {
                segmentList(title: "Geographic Segments", items: geography)
            }

            if let productType = segments.productType, !productType.isEmpty {
                segmentList(title: "Product Segments", items: productType)
            }
        }
    }

    private func segmentList(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacingSize: .xs) {
            Text(title)
                .font(.plusJakartaSans(.caption))
                .foregroundStyle(Color.secondary)

            ForEach(items, id: \.self) { item in
                HStack(spacingSize: .xs) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .foregroundStyle(Color.tint)

                    Text(item)
                        .font(.plusJakartaSans(.callout))
                }
            }
        }
    }

    private func growthRateView(_ growthRate: GrowthRate) -> some View {
        VStack(alignment: .leading, spacingSize: .sm) {
            HStack {
                Text("Market Growth Rate")
                    .font(.plusJakartaSans(.subheadline, weight: .medium))

                Spacer()

                if let value = growthRate.value {
                    Text(value)
                        .font(.plusJakartaSans(.title3, weight: .bold))
                        .foregroundStyle(Color.green)
                }
            }

            if let timeframe = growthRate.timeframe {
                Text("Timeframe: \(timeframe)")
                    .font(.plusJakartaSans(.caption))
                    .foregroundStyle(Color.secondary)
            }

            if let drivers = growthRate.drivers, !drivers.isEmpty {
                Text("Growth Drivers:")
                    .font(.plusJakartaSans(.caption))
                    .foregroundStyle(Color.secondary)
                    .padding(.top, .xs)

                ForEach(drivers, id: \.self) { driver in
                    HStack(alignment: .center, spacingSize: .xs) {
                        Image(systemName: "arrow.up.right")
                            .foregroundStyle(Color.green)

                        Text(driver)
                    }
                    .font(.plusJakartaSans(.callout))
                }
            }
        }
        .padding(.all, .md)
        .background(
            RoundedRectangle(cornerSize: .md)
                .fill(Color.secondary.opacity(0.1))
        )
    }

    private func demographicsView(_ demographics: [Demographic]) -> some View {
        VStack(alignment: .leading, spacingSize: .sm) {
            Text("Target Demographics")
                .font(.plusJakartaSans(.subheadline, weight: .medium))

            ForEach(demographics.indices, id: \.self) { index in
                let demographic = demographics[index]
                demographicCard(demographic, index: index)
            }
        }
        .padding(.all, .md)
        .background(
            RoundedRectangle(cornerSize: .md)
                .fill(Color.secondary.opacity(0.1))
        )
    }

    private func demographicCard(_ demographic: Demographic, index _: Int) -> some View {
        VStack(alignment: .leading, spacingSize: .xs) {
            if let segment = demographic.segment {
                Text(segment)
                    .font(.plusJakartaSans(.callout, weight: .medium))
            }

            if let behavior = demographic.behavior {
                Text(behavior)
                    .font(.plusJakartaSans(.caption))
                    .foregroundStyle(Color.secondary)
            }

            if let source = demographic.source {
                Text("Source: \(source)")
                    .font(.plusJakartaSans(.caption2))
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding(.all, .sm)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerSize: .sm)
                .fill(Color.secondary.opacity(0.1))
        )
    }

    private func formatCurrency(_ value: Int) -> String {
        return "$\(value.formatted(.humanReadable))"
    }
}

#Preview {
    MarketAnalysisView(
        market: Market(
            tam: TAM(
                value: 4_500_000_000,
                segments: Segments(
                    geography: ["North America", "Europe", "Asia Pacific"],
                    productType: ["Mobile Apps", "SaaS Solutions", "Enterprise Services"]
                )
            ),
            growthRate: GrowthRate(
                value: "12.5% CAGR",
                timeframe: "2023-2028",
                drivers: [
                    "Increasing digital transformation",
                    "Growing demand for AI solutions",
                    "Rising adoption in emerging markets",
                ]
            ),
            demographics: [
                Demographic(
                    segment: "Tech-savvy Millennials",
                    behavior: "Early adopters of new technologies",
                    source: "Industry Report 2023"
                ),
                Demographic(
                    segment: "Small Business Owners",
                    behavior: "Looking for cost-effective solutions",
                    source: "Market Survey"
                ),
            ]
        ),
        competitors: [
            Competitor(
                name: "Competitor A",
                weakness: "Outdated technology stack",
                differentiator: "AI-powered recommendations"
            ),
            Competitor(
                name: "Competitor B",
                weakness: "Limited market reach",
                differentiator: "Global scalability from day one"
            ),
        ]
    )
    .padding()
}
