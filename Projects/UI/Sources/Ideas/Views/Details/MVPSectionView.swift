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
                        HStack(alignment: .top, spacingSize: .sm) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.themeSecondary)
                                .font(.system(size: 18))

                            Text(milestone)
                                .font(.plusJakartaSans(.subheadline))
                        }
                    }
                }
            }
        }
        .padding(.all, .lg)
        .background(
            RoundedRectangle(cornerRadius: Size.md.rawValue)
                .fill(Color.themeSecondary.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: Size.md.rawValue)
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
