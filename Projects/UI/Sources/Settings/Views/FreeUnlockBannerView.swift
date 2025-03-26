import AppResources
import Core
import SwiftUI

struct FreeUnlockBannerView: View {
    let isAvailable: Bool
    let nextUnlockDate: Date?
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: Size.sm.rawValue) {
            if isAvailable {
                DisclosureGroup(
                    isExpanded: $isExpanded,
                    content: unlockDetailsView,
                    label: {
                        HStack {
                            Image(systemName: "gift.fill")

                            Text("Free Unlock Available!")
                                .font(.plusJakartaSans(.headline))
                        }
                        .foregroundStyle(Color.green)
                    }
                )
                .foregroundStyle(Color.systemLabel)
                .tint(.green)
            } else if let nextUnlockDate = nextUnlockDate {
                HStack {
                    Image(systemName: "clock.fill")
                    Text("Next Free Unlock: ")
                    Spacer()
                    Text(nextUnlockDate, style: .date)
                }
                .font(.plusJakartaSans(.subheadline, weight: .medium))
                .foregroundStyle(Color.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Size.md.rawValue)
                .fill(isAvailable ? Color.green : Color.secondary)
                .opacity(0.1)
        )
        .transaction { transaction in
            transaction.animation = .snappy
        }
    }

    private func bulletPoint(_ text: String) -> some View {
        HStack(alignment: .top, spacing: Size.xs.rawValue) {
            Text("•")
                .foregroundStyle(Color.secondary)
            Text(text)
        }
    }

    private func unlockDetailsView() -> some View {
        VStack(alignment: .leading, spacing: Size.sm.rawValue) {
            Text("Free Unlock Details")
                .font(.plusJakartaSans(.subheadline, weight: .medium))

            Text("You can unlock any idea for free once per week. This gives you access to the full analysis, including financial projections, market research, and technical details.")
                .font(.plusJakartaSans(.subheadline))

            Text("To use your free unlock:")
                .font(.plusJakartaSans(.subheadline, weight: .medium))
                .padding(.top, Size.xs.rawValue)

            VStack(alignment: .leading, spacing: Size.xs.rawValue) {
                bulletPoint("Browse ideas in the feed")
                bulletPoint("Tap on an idea you're interested in")
                bulletPoint("Click 'Unlock Idea'")
                bulletPoint("Congratulations! You now have full access to that idea.")
            }
            .font(.plusJakartaSans(.subheadline))
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.top, Size.sm.rawValue)
    }
}

#if DEBUG
    #Preview("Available") {
        FreeUnlockBannerView(
            isAvailable: true,
            nextUnlockDate: nil
        )
        .padding()
    }

    #Preview("Not Available") {
        FreeUnlockBannerView(
            isAvailable: false,
            nextUnlockDate: Date().addingTimeInterval(7 * 24 * 60 * 60)
        )
        .padding()
    }
#endif
