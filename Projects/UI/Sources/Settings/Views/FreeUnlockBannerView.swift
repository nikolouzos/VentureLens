import AppResources
import Core
import SwiftUI

struct FreeUnlockBannerView: View {
    let isAvailable: Bool
    let nextUnlockDate: Date?
    @State private var isExpanded = false

    var body: some View {
        VStack(spacingSize: .sm) {
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
            } else if let nextUnlockDate {
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
        .padding(.all, .md)
        .background(
            RoundedRectangle(cornerRadius: Size.md.rawValue)
                .fill(isAvailable ? Color.themeSecondary : Color.secondary)
                .opacity(0.2)
        )
        .animation(.snappy, value: isExpanded)
    }

    private func bulletPoint(_ text: String) -> some View {
        HStack(alignment: .top, spacingSize: .xs) {
            Text("•")
                .foregroundStyle(Color.secondary)
            Text(text)
        }
    }

    private func unlockDetailsView() -> some View {
        VStack(alignment: .leading, spacingSize: .sm) {
            Text("Free Unlock Details")
                .font(.plusJakartaSans(.subheadline, weight: .medium))
                .padding(.top, .sm)

            Text("You can unlock any idea for free once per week. This gives you access to the full analysis, including financial projections, market research, and technical details.")
                .font(.plusJakartaSans(.subheadline))

            Text("To use your free unlock:")
                .font(.plusJakartaSans(.subheadline, weight: .medium))
                .padding(.top, .xs)

            VStack(alignment: .leading, spacingSize: .xs) {
                bulletPoint("Browse ideas in the feed")
                bulletPoint("Tap on an idea you're interested in")
                bulletPoint("Click 'Unlock Idea'")
                bulletPoint("Congratulations! You now have full access to that idea.")
            }
            .transition(.identity)
            .font(.plusJakartaSans(.subheadline))
        }
        .fixedSize(horizontal: false, vertical: isExpanded)
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
