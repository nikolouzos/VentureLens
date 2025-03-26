import Charts
import Core
import Networking
import SwiftUI

/// A view that displays validation metrics information for an idea
struct ValidationMetricsView: View {
    let metrics: ValidationMetrics?

    var body: some View {
        VStack(alignment: .leading, spacingSize: .md) {
            SectionHeaderView(title: "Validation Metrics")

            if let metrics = metrics {
                // Summary metrics
                HStack(spacingSize: .md) {
                    if let signups = metrics.prelaunchSignups {
                        metricCard(
                            title: "Pre-launch Signups",
                            value: "\(signups)",
                            systemImage: "person.3.fill",
                            color: Color.tint
                        )
                    }

                    if let conversionRate = metrics.pilotConversionRate {
                        metricCard(
                            title: "Pilot Conversion",
                            value: conversionRate,
                            systemImage: "chart.line.uptrend.xyaxis",
                            color: .green
                        )
                    }
                }

                // Early adopter segments
                if let segments = metrics.earlyAdopterSegments, !segments.isEmpty {
                    earlyAdopterSegmentsView(segments)
                }
            } else {
                Text("No validation metrics available")
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding(.vertical, .md)
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
            RoundedRectangle(cornerRadius: Size.md.rawValue)
                .fill(Color.secondary.opacity(0.1))
        )
    }

    private func earlyAdopterSegmentsView(_ segments: [EarlyAdopterSegment]) -> some View {
        VStack(alignment: .leading, spacingSize: .sm) {
            Text("Early Adopter Segments")
                .font(.plusJakartaSans(.subheadline, weight: .medium))

            // Chart for early adopter segments
            Chart {
                ForEach(segments.indices, id: \.self) { index in
                    let segment = segments[index]
                    if let group = segment.group, let percentageStr = segment.percentage {
                        let percentage = parsePercentage(percentageStr)
                        SectorMark(
                            angle: .value("Percentage", percentage),
                            innerRadius: .ratio(0.6),
                            angularInset: 1.5
                        )
                        .foregroundStyle(by: .value("Group", group))
                        .annotation(position: .overlay) {
                            Text("\(Int(percentage))%")
                                .font(.plusJakartaSans(.caption, weight: .bold))
                                .foregroundStyle(Color.white)
                        }
                    }
                }
            }
            .frame(height: 200)

            // Legend
            VStack(alignment: .leading, spacingSize: .xs) {
                ForEach(segments.indices, id: \.self) { index in
                    let segment = segments[index]
                    if let group = segment.group, let percentage = segment.percentage {
                        HStack(spacingSize: .sm) {
                            Circle()
                                .fill(segmentColor(index))
                                .frame(width: 12, height: 12)

                            Text("\(group): \(percentage)")
                                .font(.plusJakartaSans(.callout))
                        }
                    }
                }
            }
            .padding(.top, .sm)
        }
        .padding(.all, .md)
        .background(
            RoundedRectangle(cornerRadius: Size.md.rawValue)
                .fill(Color.secondary.opacity(0.1))
        )
    }

    private func segmentColor(_ index: Int) -> Color {
        let colors: [Color] = [
            .blue, .green, .orange, .purple, .pink, .yellow, .red,
        ]
        return colors[index % colors.count]
    }

    private func parsePercentage(_ percentageStr: String) -> Double {
        let cleaned = percentageStr.replacingOccurrences(of: "%", with: "")
        return Double(cleaned) ?? 0.0
    }
}

#Preview {
    ValidationMetricsView(metrics: ValidationMetrics(
        prelaunchSignups: 2500,
        pilotConversionRate: "32%",
        earlyAdopterSegments: [
            EarlyAdopterSegment(group: "Tech Enthusiasts", percentage: "45%"),
            EarlyAdopterSegment(group: "Small Business Owners", percentage: "30%"),
            EarlyAdopterSegment(group: "Students", percentage: "15%"),
            EarlyAdopterSegment(group: "Others", percentage: "10%"),
        ]
    ))
    .padding()
}
