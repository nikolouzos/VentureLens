import Core
import Networking
import SwiftUI

/// A view that displays roadmap information for an idea
struct RoadmapView: View {
    let roadmap: [RoadmapPhase]?

    private var mvpPhase: RoadmapPhase? {
        roadmap?.first(where: { ($0.phase ?? "").lowercased().contains("mvp") })
    }

    private var otherPhases: [RoadmapPhase]? {
        guard let roadmap = roadmap else { return nil }
        return roadmap.filter { !($0.phase ?? "").lowercased().contains("mvp") }
    }

    var body: some View {
        VStack(alignment: .leading, spacingSize: .md) {
            SectionHeaderView(title: "Product Roadmap")

            if let roadmap = roadmap, !roadmap.isEmpty {
                // MVP Phase (highlighted)
                if let mvp = mvpPhase {
                    MVPSectionView(mvpPhase: mvp)
                        .padding(.bottom, .md)
                }

                // Other phases
                if let others = otherPhases, !others.isEmpty {
                    Text("Development Phases")
                        .font(.plusJakartaSans(.subheadline, weight: .medium))

                    ForEach(others.indices, id: \.self) { index in
                        let phase = others[index]
                        phaseCard(phase, index: index, total: others.count)
                    }
                }
            } else {
                Text("No roadmap information available")
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding(.vertical, .md)
    }

    private func phaseCard(_ phase: RoadmapPhase, index _: Int, total _: Int) -> some View {
        VStack(alignment: .leading, spacingSize: .sm) {
            HStack {
                if let phaseName = phase.phase {
                    Text(phaseName)
                        .font(.plusJakartaSans(.title3, weight: .semibold))
                }

                Spacer()

                if let timeline = phase.timelineMonths {
                    Text("\(timeline) months")
                        .font(.plusJakartaSans(.callout))
                        .foregroundStyle(Color.secondary)
                        .padding(.horizontal, .sm)
                        .padding(.vertical, .xs)
                        .background(
                            Capsule()
                                .fill(Color.secondary.opacity(0.1))
                        )
                }
            }

            if let milestones = phase.milestones, !milestones.isEmpty {
                VStack(alignment: .leading, spacingSize: .xs) {
                    Text("Key Milestones:")
                        .font(.plusJakartaSans(.caption))
                        .foregroundStyle(Color.secondary)

                    ForEach(milestones, id: \.self) { milestone in
                        HStack(alignment: .top, spacingSize: .sm) {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 6))
                                .foregroundStyle(Color.secondary)
                                .padding(.top, 6)

                            Text(milestone)
                                .font(.plusJakartaSans(.subheadline))
                        }
                    }
                }
            }
        }
        .padding(.all, .md)
        .background(
            RoundedRectangle(cornerRadius: Size.md.rawValue)
                .fill(Color.secondary.opacity(0.1))
        )
        .padding(.bottom, .sm)
    }
}

#Preview {
    RoadmapView(roadmap: [
        RoadmapPhase(
            phase: "MVP",
            timelineMonths: 3,
            milestones: [
                "User authentication and profile creation",
                "Basic habit tracking functionality",
                "Simple analytics dashboard",
                "Notification system for reminders",
            ]
        ),
        RoadmapPhase(
            phase: "Beta Release",
            timelineMonths: 2,
            milestones: [
                "Advanced analytics",
                "Social sharing features",
                "Integration with health apps",
            ]
        ),
        RoadmapPhase(
            phase: "Public Launch",
            timelineMonths: 1,
            milestones: [
                "Premium subscription tier",
                "Cross-platform support",
                "Marketing campaign launch",
            ]
        ),
    ])
    .padding()
}
