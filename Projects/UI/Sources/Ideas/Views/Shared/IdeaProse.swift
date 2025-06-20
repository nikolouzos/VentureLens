import AppResources
import Core
import Networking
import SwiftUI

struct IdeaProse: View {
    let idea: Idea

    private var gradientStops: [Color] {
        guard idea.imageUrl != nil else {
            return []
        }
        return [
            Color.black,
            Color.black.opacity(0.9),
            Color.black.opacity(0.6),
            Color.clear,
        ]
    }

    private var hasImage: Bool {
        idea.imageUrl != nil
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            imageCover()

            VStack {
                CategoryBadge(category: idea.category)

                Text(idea.title)
                    .font(.plusJakartaSans(.title2, weight: .bold))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .foregroundStyle(
                        hasImage ? Color.white : Color.systemLabel
                    )
                    .frame(maxWidth: .infinity)
            }
            .padding(.all, .lg)
            .background(
                LinearGradient(
                    colors: gradientStops,
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
        }
    }

    @ViewBuilder
    private func imageCover() -> some View {
        if let imageUrl = idea.imageUrl {
            CachedAsyncImage(url: imageUrl) { image in
                image.resizable()
            } placeholder: {
                Rectangle()
                    .fill(Color.gray)
                    .overlay {
                        ProgressView()
                    }
                    .tint(.white)
            } failure: { _ in

                LinearGradient(
                    gradient: Gradient(
                        colors: [.themeSecondary, .accentColor]
                    ),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            .aspectRatio(5 / 3, contentMode: .fit)
            .ignoresSafeArea(edges: .top)
        }
    }
}

private struct CategoryBadge: View {
    let category: String

    var body: some View {
        Text(category)
            .font(.plusJakartaSans(.caption2, weight: .semibold))
            .padding(.horizontal, .sm)
            .padding(.vertical, .xs)
            .background(Color.themeSecondary)
            .clipShape(RoundedRectangle(cornerSize: .xs))
    }
}

#if DEBUG
    #Preview {
        IdeaProse(idea: IdeaPreviews.standard)
    }
#endif
