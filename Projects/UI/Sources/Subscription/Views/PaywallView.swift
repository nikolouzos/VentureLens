import Core
import Dependencies
import SwiftUI

// MARK: - Main Paywall View

public struct PaywallView: View {
    @StateObject private var viewModel: PaywallViewModel
    @Environment(\.dismiss) private var dismiss

    public init(viewModel: PaywallViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(spacingSize: .lg) {
                header

                if viewModel.isLoading {
                    loadingView

                } else if let errorMessage = viewModel.errorMessage {
                    errorView(errorMessage)

                } else if viewModel.monthlyProduct != nil || viewModel.annualProduct != nil {
                    contentView

                } else {
                    errorView("Subscription options are currently unavailable. Please try again later.")
                }
            }
            .padding(.all, .lg)
        }
        .task {
            await viewModel.loadProducts()
        }
        .overlay(purchaseSuccessOverlay)
        .animation(.easeInOut, value: viewModel.purchaseSuccess)
    }

    // MARK: - Subviews

    private var header: some View {
        VStack(spacingSize: .sm) {
            Text("Upgrade to VentureLens Premium")
                .font(.plusJakartaSans(.largeTitle, weight: .bold))
                .multilineTextAlignment(.center)

            Text("Unlock data-driven insights & actionable plans.")
                .font(.plusJakartaSans(.subheadline))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, .md)
    }

    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
            Spacer()
        }
    }

    private func errorView(_ message: String) -> some View {
        VStack {
            Spacer()
            VStack(spacingSize: .md) {
                Text("Oops!")
                    .font(.title)
                    .fontWeight(.bold)

                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                Button("Try Again") {
                    Task {
                        await viewModel.loadProducts()
                    }
                }
                .buttonStyle(ProminentButtonStyle())
                .disabled(viewModel.isLoading)
            }
            Spacer()
        }
    }

    private var contentView: some View {
        VStack(spacingSize: .lg) {
            planSelector
            comparisonSection
            upgradeButton
            restoreButton
            legalTextView
        }
    }

    private var planSelector: some View {
        VStack(spacingSize: .xs) {
            Picker("Plan", selection: $viewModel.selectedPlan) {
                if let monthlyProduct = viewModel.monthlyProduct {
                    Text("\(PaywallViewModel.SubscriptionPlan.monthly.rawValue) \(monthlyProduct.priceString)")
                        .tag(PaywallViewModel.SubscriptionPlan.monthly)
                }
                if let annualProduct = viewModel.annualProduct {
                    Text("\(PaywallViewModel.SubscriptionPlan.annual.rawValue) \(annualProduct.priceString)")
                        .tag(PaywallViewModel.SubscriptionPlan.annual)
                }
            }
            .pickerStyle(.segmented)

            if viewModel.selectedPlan == .annual, let savings = viewModel.savingsPercentage {
                Text("Save \(savings)% - Most Popular")
                    .font(.plusJakartaSans(.caption, weight: .medium))
                    .foregroundColor(.tint)
            }
        }
    }

    private var comparisonSection: some View {
        VStack(alignment: .leading, spacingSize: .md) {
            Text("Compare Plans")
                .font(.plusJakartaSans(.title3, weight: .bold))

            HStack(alignment: .top, spacingSize: .md) {
                PlanComparisonCard(
                    planName: "Free",
                    price: nil,
                    features: viewModel.featureComparison.map { ($0.id, $0.freeAccess) },
                    description: "Great for exploring ideas"
                )
                PlanComparisonCard(
                    planName: "Premium",
                    price: viewModel.selectedProduct?.priceString ?? "N/A",
                    features: viewModel.featureComparison.map { ($0.id, $0.premiumAccess) },
                    description: nil,
                    isPremium: true
                )
            }
        }
    }

    private var upgradeButton: some View {
        Button {
            guard let product = viewModel.selectedProduct else { return }
            Task {
                await viewModel.purchase(productID: product.id)
            }
        } label: {
            VStack(spacingSize: .xs) {
                Text("Upgrade Now - \(viewModel.selectedProduct?.priceString ?? "")")
                Text(viewModel.selectedPlan == .annual ? "(Billed Annually)" : "(Billed Monthly)")
                    .font(.plusJakartaSans(.caption, weight: .semibold))
            }
        }
        .buttonStyle(
            ProminentButtonStyle(
                isLoading: viewModel.isPurchasing,
                fullWidth: true
            )
        )
        .disabled(viewModel.isPurchasing || viewModel.selectedProduct == nil)
    }

    private var restoreButton: some View {
        Button {
            Task {
                await viewModel.restorePurchases()
            }
        } label: {
            if viewModel.isRestoring {
                ProgressView()
            } else {
                Text("Restore Purchases")
                    .font(.plusJakartaSans(.subheadline))
            }
        }
        .buttonStyle(TextButtonStyle())
        .disabled(viewModel.isRestoring)
    }

    private var legalTextView: some View {
        Text("Subscriptions will automatically renew unless canceled at least 24 hours before the end of the current period. You can manage your subscriptions in your App Store account settings.")
            .font(.plusJakartaSans(.caption))
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, .lg)
    }

    @ViewBuilder
    private var purchaseSuccessOverlay: some View {
        if viewModel.purchaseSuccess {
            SuccessOverlay {
                viewModel.dismissPurchaseSuccess()
                dismiss()
            }
            .transition(.opacity.animation(.easeInOut))
        }
    }
}

// MARK: - Plan Comparison Card

struct PlanComparisonCard: View {
    let planName: String
    let price: String?
    let features: [(id: UUID, feature: String)]
    let description: String?
    var isPremium: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacingSize: .zero) {
            VStack(alignment: .center, spacingSize: .xs) {
                Text(planName)
                    .font(.plusJakartaSans(.headline, weight: .bold))
                if let price {
                    Text(price)
                        .font(.plusJakartaSans(.subheadline))
                } else {
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, .md)
            .background(isPremium ? Color.blue.opacity(0.1) : Color(.systemGray5))

            Divider()

            VStack(alignment: .leading, spacingSize: .sm) {
                ForEach(features, id: \.id) { _, feature in
                    Text(feature)
                        .font(.plusJakartaSans(.caption))
                }
            }
            .padding(.all, .md)

            if let description {
                Spacer()
                Divider()
                Text(description)
                    .font(.plusJakartaSans(.caption2, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding(.all, .md)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            Spacer(minLength: 0)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerSize: .md))
        .overlay(
            RoundedRectangle(cornerSize: .md)
                .stroke(isPremium ? Color.blue : Color(.systemGray4), lineWidth: isPremium ? 2 : 1)
        )
    }
}

// MARK: - Success Overlay (Keep as is)

struct SuccessOverlay: View {
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    onDismiss()
                }

            VStack(spacingSize: .lg) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.green)

                Text("Purchase Successful!")
                    .font(.plusJakartaSans(.title2, weight: .bold))
                    .foregroundColor(.white)

                Text("Thank you for your purchase. Enjoy premium features!")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.8))

                Button(action: onDismiss) {
                    Text("Continue")
                }
                .buttonStyle(OutlineButtonStyle())
                .padding(.top, .sm)
            }
            .padding(.all, .xl)
            .background(Material.ultraThinMaterial)
            .clipShape(
                RoundedRectangle(cornerSize: .md)
            )
            .padding(.all, .xl)
        }
    }
}

// MARK: - Preview

// #Preview {
//    // Mock Dependencies and ViewModel for Preview
//    class MockInAppPurchasesManager: InAppPurchasesManager {
//        func getProducts() async throws -> [Product] {
//            [
//                Product(id: "com.example.monthly", title: "Monthly Plan", description: "Access all features month-to-month.", price: 2.99, priceString: "£2.99"),
//                Product(id: "com.example.yearly", title: "Yearly Plan", description: "Save with annual billing.", price: 29.99, priceString: "£29.99")
//            ]
//        }
//        func purchase(productID: String) async throws -> Transaction {
//            // Mock transaction
//            throw URLError(.cancelled) // Simulate cancellation for preview
//        }
//        func restorePurchases() async throws -> Bool {
//            true
//        }
//        func getCurrentEntitlements() async throws -> [SubscriptionTier : EntitlementInfo] {
//            [:]
//        }
//        func listenForTransactions() -> Task<Void, Error> {
//            Task { }
//        }
//    }
//
//    struct MockDependencies: DependenciesContainer {
//        var inAppPurchasesManager: InAppPurchasesManager = MockInAppPurchasesManager()
//        // Add other necessary mock dependencies if PaywallViewModel uses them
//    }
//
//    let mockViewModel = PaywallViewModel(
//        dependencies: MockDependencies()
//    )
//
//    return PaywallView(viewModel: mockViewModel)
// }
