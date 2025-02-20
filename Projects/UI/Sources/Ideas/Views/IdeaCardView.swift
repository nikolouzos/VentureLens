import AppResources
import Core
import Networking
import SwiftUI

struct IdeaCardView: View {
    let idea: Idea

    var body: some View {
        VStack(alignment: .leading, spacingSize: .md) {
            CardProse(idea: idea)
            
            VStack(alignment: .leading, spacingSize: .md) {
                Text(idea.summary)
                    .font(.subheadline)
                    .foregroundStyle(Color.accentColor)
                    .lineLimit(3)

                if let fullDetails = idea.fullDetails, !fullDetails.isEmpty {
                    Text(fullDetails)
                        .font(.caption)
                        .lineLimit(2)
                        .padding(.bottom, .xs)
                }

                if let report = idea.report {
                    VStack(alignment: .leading, spacingSize: .md) {
                        HStack {
                            Label(
                                "Est. Value: \(report.estimatedValue)",
                                systemImage: "arrow.up"
                            )
                            .foregroundStyle(Color.accentColor)

                            Spacer()
                            Text(idea.createdAt, style: .date)
                                .foregroundStyle(Color.accentColor)
                        }

                        HStack {
                            Label(
                                "Est. Cost: \(report.estimatedCost)",
                                systemImage: "arrow.down"
                            )
                            .font(.caption)
                            .foregroundStyle(Color.red)
                        }
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                }
            }
            .padding(.all, .lg)
        }
        .background(
            Color(UIColor.systemBackground)
        )
        .clipShape(RoundedRectangle(cornerSize: .md))
        .shadow(
            color: Color.gray.opacity(0.2),
            radius: Size.sm.rawValue
        )
        .padding(.all, .lg)
    }
}

struct CardProse: View {
    let idea: Idea
    
    private var gradientStops: [Color] {
        guard idea.imageUrl != nil else {
            return []
        }
        return [
            Color.black,
            Color.black.opacity(0.7),
            Color.black.opacity(0.7),
            Color.clear
        ]
    }
    
    private var hasImage: Bool {
        idea.imageUrl != nil
    }
    
    private var cornerRadius: CGFloat {
        hasImage ? Size.lg.rawValue : .zero
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            imageCover()
            
            HStack(alignment: .top) {
                Text(idea.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .foregroundStyle(
                        hasImage ? Color.white : Color.black
                    )
                Spacer()
                CategoryBadge(category: idea.category)
            }
            .padding(.all, cornerRadius)
            .background(
                LinearGradient(
                    colors: gradientStops,
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
        }
        .padding(.all, !hasImage ? Size.md.rawValue : .zero)
    }
    
    @ViewBuilder
    private func imageCover() -> some View {
        if let imageUrl = idea.imageUrl {
            AsyncImage(url: imageUrl) { phase in
                if let image = phase.image {
                    image.resizable()
                } else {
                    Rectangle()
                        .fill(Color.gray)
                        .overlay {
                            if phase.error != nil {
                                Text("Image not available")
                            } else {
                                ProgressView()
                            }
                        }
                        .tint(.white)
                }
            }
            .aspectRatio(4/3, contentMode: .fit)
        }
    }
}

fileprivate struct CategoryBadge: View {
    let category: String

    var body: some View {
        Text(category)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, .sm)
            .padding(.vertical, .xs)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(Size.xs.rawValue)
    }
}

#Preview {
    IdeaCardView(idea: .mock)
}
