import AppResources
import Core
import Dependencies
import Networking
import SwiftData
import SwiftUI

struct IdeaDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel: IdeaDetailViewModel

    init(viewModel: IdeaDetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacingSize: .lg) {
                ZStack(alignment: .top) {
                    IdeaProse(idea: viewModel.idea)
                        .padding(.top, viewModel.idea.imageUrl == nil ? .xxl : .zero)

                    sheetNavigationBarButtons
                }

                VStack(alignment: .leading, spacingSize: .lg) {
                    VStack(alignment: .leading, spacingSize: .md) {
                        financialOverviewView

                        Text(viewModel.idea.summary)
                            .foregroundStyle(Color.gray)
                            .font(.plusJakartaSans(.body, weight: .medium))
                    }

                    if let user = viewModel.currentUser,
                       !viewModel.isPremiumUser &&
                       !viewModel.hasUnlockedIdea
                    {
                        UnlockIdeaCardView(
                            viewModel: UnlockIdeaViewModel(
                                user: user,
                                ideaId: viewModel.idea.id.uuidString,
                                apiClient: viewModel.apiClient,
                                authentication: viewModel.authentication
                            ),
                            onUnlocked: {
                                // TODO: Refresh user & idea data
                            }
                        )
                    }

                    tabSelectionView
                    activeTabView

                    HStack {
                        Spacer()
                        Text("Created: \(viewModel.idea.createdAt, style: .date)")
                            .font(.plusJakartaSans(.caption))
                            .foregroundStyle(Color.tint)
                    }
                }
                .padding(.all, .lg)
            }
        }
        .task {
            viewModel.onAppear()
        }
        .onDisappear(perform: viewModel.onDisappear)
        .disabled(viewModel.isLoading)
    }

    // MARK: - Subviews

    private var sheetNavigationBarButtons: some View {
        HStack {
            Circle()
                .fill(Color.gray.opacity(0.5))
                .overlay {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .padding(.all, 10)
                }
                .frame(widthSize: .xl, heightSize: .xl)
                .onTapGesture { dismiss() }

            Spacer()

            Button {
                Task {
                    await viewModel.toggleBookmark()
                }
            }
            label: {
                Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(widthSize: .lg)
            }
        }
        .padding(.all, .lg)
    }

    private var financialOverviewView: some View {
        Group {
            if let report = viewModel.idea.report, let financials = report.financials {
                HStack {
                    Label(
                        "Year 1 Revenue: \(NumberFormatter.usdCurrency.string(from: financials.totalYear1Revenue) ?? "-")",
                        systemImage: "arrow.up"
                    )
                    .foregroundStyle(Color.green)

                    Spacer()

                    Label(
                        "Year 1 Costs: \(NumberFormatter.usdCurrency.string(from: financials.totalYear1Costs) ?? "-")",
                        systemImage: "arrow.down"
                    )
                    .foregroundStyle(Color.themePrimary)
                }
                .padding(.bottom, .sm)
            }
            Divider()
        }
        .font(.plusJakartaSans(.caption, weight: .medium))
    }

    @ViewBuilder
    private var overviewView: some View {
        if let fullDetails = viewModel.idea.fullDetails {
            VStack(alignment: .leading, spacingSize: .md) {
                SectionHeaderView(title: "Full Analysis")

                Text(fullDetails)
                    .lineSpacing(8)
            }
        } else {
            noDataView(for: viewModel.selectedTab.title)
        }
    }

    private var tabSelectionView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacingSize: .md) {
                ForEach(DetailTab.allCases, id: \.self) { tab in
                    tabButton(tab)
                }
            }
            .padding(.vertical, .sm)
        }
    }

    @ViewBuilder
    private var activeTabView: some View {
        switch viewModel.selectedTab {
        case .overview:
            overviewView

        case .financial:
            if let report = viewModel.idea.report, let financials = report.financials {
                FinancialAnalysisView(financials: financials)
            } else {
                noDataView(for: viewModel.selectedTab.title)
            }

        case .market:
            if let report = viewModel.idea.report, let market = report.market {
                MarketAnalysisView(
                    market: market,
                    competitors: report.competitors
                )
            } else {
                noDataView(for: viewModel.selectedTab.title)
            }

        case .roadmap:
            if let report = viewModel.idea.report, let roadmap = report.roadmap {
                RoadmapView(roadmap: roadmap)
            } else {
                noDataView(for: viewModel.selectedTab.title)
            }

        case .techStack:
            if let techStack = viewModel.idea.techStack {
                TechStackView(techStack: techStack)
            } else {
                noDataView(for: viewModel.selectedTab.title)
            }

        case .ethics:
            if let ethics = viewModel.idea.ethics {
                EthicsView(ethics: ethics)
            } else {
                noDataView(for: viewModel.selectedTab.title)
            }

        case .validation:
            if let validationMetrics = viewModel.idea.validationMetrics {
                ValidationMetricsView(metrics: validationMetrics)
            } else {
                noDataView(for: viewModel.selectedTab.title)
            }
        }
    }

    private func tabButton(_ tab: DetailTab) -> some View {
        Button {
            withAnimation {
                viewModel.updateSelectedTab(tab)
            }
        }
        label: {
            Text(tab.title)
                .font(.plusJakartaSans(
                    .subheadline,
                    weight: viewModel.selectedTab == tab ? .bold : .regular
                ))
                .padding(.horizontal, .md)
                .padding(.vertical, .sm)
                .background(
                    Capsule()
                        .fill(viewModel.selectedTab == tab ? Color.themePrimary : Color.secondary.opacity(0.1))
                )
                .foregroundStyle(viewModel.selectedTab == tab ? .white : .primary)
        }
    }

    private func noDataView(for section: String) -> some View {
        VStack(spacingSize: .md) {
            if !viewModel.isPremiumUser && !viewModel.hasUnlockedIdea {
                Image(systemName: "lock.fill")
                    .font(.plusJakartaSans(.largeTitle))
                    .foregroundStyle(Color.themePrimary)
            } else {
                Image(systemName: "exclamationmark.triangle")
                    .font(.plusJakartaSans(.largeTitle))
                    .foregroundStyle(Color.orange)
            }

            Text("No \(section) data available")
                .font(.plusJakartaSans(.headline))
                .multilineTextAlignment(.center)

            if !viewModel.isPremiumUser && !viewModel.hasUnlockedIdea {
                Text("This content is locked. Unlock the idea to view the full analysis.")
                    .font(.plusJakartaSans(.subheadline))
                    .foregroundStyle(Color.secondary)
                    .multilineTextAlignment(.center)

                Text("Have you unlocked this idea?")
                    .font(.plusJakartaSans(.callout, weight: .medium))
                    .foregroundStyle(Color.tint)
            } else {
                Text("No idea information found for the \(section) section.")
                    .font(.plusJakartaSans(.subheadline))
                    .foregroundStyle(Color.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.all, .lg)
        .background(
            RoundedRectangle(cornerRadius: Size.md.rawValue)
                .fill(Color.secondary.opacity(0.1))
        )
    }
}

#if DEBUG
    import AppResources
    import Dependencies

    #Preview {
        NavigationView {
            IdeaDetailView(
                viewModel: IdeaDetailViewModel(
                    idea: .mock,
                    apiClient: MockAPIClient(),
                    authentication: MockAuthentication()
                )
            )
        }
    }
#endif
