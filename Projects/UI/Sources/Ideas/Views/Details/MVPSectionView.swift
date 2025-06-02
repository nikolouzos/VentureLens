import AppResources
import Core
import Networking
import SwiftUI

/// A view that displays the MVP phase information for an idea
struct MVPSectionView: View {
    let mvpPhase: RoadmapPhase

    var body: some View {
        VStack(alignment: .leading, spacingSize: .md) {
            HStack {
                Text("MVP Development")
                    .font(.plusJakartaSans(.title2, weight: .bold))
                    .foregroundStyle(Color.tint)

                Spacer()

                if let timeline = mvpPhase.timelineMonths {
                    Text("\(timeline) months")
                        .font(.plusJakartaSans(.callout))
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, .sm)
                        .padding(.vertical, .xs)
                        .background(
                            Capsule()
                                .fill(Color.themeSecondary)
                        )
                }
            }

            if let milestones = mvpPhase.milestones, !milestones.isEmpty {
                VStack(alignment: .leading, spacingSize: .sm) {
                    Text("Key MVP Milestones:")
                        .font(.plusJakartaSans(.headline))
                        .foregroundStyle(Color.secondary)

                    ForEach(milestones, id: \.self) { milestone in
                        HStack(alignment: .center, spacingSize: .sm) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.themeSecondary)
                                .font(.plusJakartaSans(.title3))

                            Text(milestone)
                                .font(.plusJakartaSans(.subheadline))
                        }
                    }
                }
            }
        }
        .padding(.all, .lg)
        .background(
            RoundedRectangle(cornerSize: .md)
                .fill(Color.themeSecondary.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerSize: .md)
                        .stroke(Color.themeSecondary, lineWidth: 2)
                )
        )
    }
}

#Preview {
    MVPSectionView(
        mvpPhase: RoadmapPhase(
            phase: "MVP",
            timelineMonths: 3,
            milestones: [
                "User authentication and profile creation",
                "Basic habit tracking functionality",
                "Simple analytics dashboard",
                "Notification system for reminders",
            ]
        )
    )
    .padding()
}
