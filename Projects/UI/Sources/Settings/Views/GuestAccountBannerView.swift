import SwiftUI

struct GuestAccountBannerView: View {
    @State private var isWaving = false

    var body: some View {
        HStack(alignment: .center, spacingSize: .md) {
            Image(systemName: "hand.wave")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(widthSize: .xl)
                .rotationEffect(.degrees(isWaving ? 0 : 20))

            Text("Let’s make it official!")
                .font(.plusJakartaSans(.subheadline, weight: .semibold)) +
                Text(" Add your email for free unlocks & bookmarks. You’ll find it in the \"Profile\" section.")
        }
        .font(.plusJakartaSans(.subheadline, weight: .medium))
        .padding(.all, .md)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerSize: .md)
                .fill(Color.yellow)
                .opacity(0.2)
        )
        .animation(.bouncy(extraBounce: 0.5).delay(0.3), value: isWaving)
        .task {
            guard !isWaving else { return }
            isWaving = true
        }
    }
}
