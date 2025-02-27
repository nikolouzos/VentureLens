import AppResources
import Core
import Networking
import SwiftUI
import SwiftData

struct IdeaDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel: IdeaDetailsViewModel
    
    init(viewModel: IdeaDetailsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacingSize: .lg) {
                // Header with image and title
                ZStack(alignment: .top) {
                    IdeaProse(idea: viewModel.idea)
                        .padding(.top, viewModel.idea.imageUrl == nil ? .xxl : .zero)
                    
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
                
                // Content sections
                VStack(alignment: .leading, spacingSize: .lg) {
                    // Summary and monetary analysis
                    VStack(alignment: .leading, spacingSize: .md) {
                        monetaryAnalysisView
                        
                        Text(viewModel.idea.summary)
                            .font(.body)
                            .foregroundStyle(Color.gray)
                            .fontWeight(.medium)
                    }
                    
                    // Tab selection for different sections
                    tabSelectionView
                    
                    // Report sections based on selected tab
                    switch  viewModel.selectedTab {
                    case .overview:
                        analysisView
                        
                    case .financial:
                        // Show detailed financial analysis
                        if let report = viewModel.idea.report, let financials = report.financials {
                            FinancialAnalysisView(financials: financials)
                        } else {
                            noDataView(for: "financial")
                        }
                        
                    case .market:
                        // Show detailed market analysis
                        if let report = viewModel.idea.report, let market = report.market {
                            MarketAnalysisView(market: market)
                        } else {
                            noDataView(for: "market")
                        }
                        
                    case .roadmap:
                        // Show detailed roadmap
                        if let report = viewModel.idea.report, let roadmap = report.roadmap {
                            RoadmapView(roadmap: roadmap)
                        } else {
                            noDataView(for: "roadmap")
                        }
                        
                    case .techStack:
                        // Show detailed tech stack
                        if let techStack = viewModel.idea.techStack {
                            TechStackView(techStack: techStack)
                        } else {
                            noDataView(for: "tech stack")
                        }
                        
                    case .ethics:
                        // Show detailed ethics & risks
                        if let ethics = viewModel.idea.ethics {
                            EthicsView(ethics: ethics)
                        } else {
                            noDataView(for: "ethics")
                        }
                        
                    case .validation:
                        // Show detailed validation metrics
                        if let validationMetrics = viewModel.idea.validationMetrics {
                            ValidationMetricsView(metrics: validationMetrics)
                        } else {
                            noDataView(for: "validation metrics")
                        }
                    }

                    HStack {
                        Spacer()
                        Text("Created: \(viewModel.idea.createdAt, style: .date)")
                            .font(.caption)
                            .foregroundStyle(Color.tint)
                    }
                }
                .padding(.all, .lg)
            }
        }
        .task {
            await viewModel.updateBookmark()
        }
        .disabled(viewModel.isLoading)
    }

    // MARK: - Subviews

    private var monetaryAnalysisView: some View {
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
        .font(.caption)
        .fontWeight(.medium)
    }

    @ViewBuilder
    private var analysisView: some View {
        if let fullDetails = viewModel.idea.fullDetails {
            VStack(alignment: .leading, spacingSize: .md) {
                SectionHeaderView(title: "Full Analysis")
                
                Text(fullDetails)
                    .font(.body)
            }
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
    
    private func tabButton(_ tab: DetailTab) -> some View {
        Button {
            withAnimation {
                viewModel.updateSelectedTab(tab)
            }
        }
        label: {
            Text(tab.title)
                .font(.subheadline)
                .fontWeight( viewModel.selectedTab == tab ? .bold : .regular)
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
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(Color.orange)
            
            Text("No \(section) data available")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text("This viewModel.idea doesn't include \(section) information.")
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
                .multilineTextAlignment(.center)
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

#Preview {
    NavigationView {
        IdeaDetailView(
            viewModel: IdeaDetailsViewModel(idea: .mock)
        )
    }
}
#endif
