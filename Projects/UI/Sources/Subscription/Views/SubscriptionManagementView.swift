import AppResources
import Core
import Dependencies
import SwiftUI
import UIKit

public struct SubscriptionManagementView: View {
    @StateObject private var viewModel: PaywallViewModel
    @Environment(\.dismiss) private var dismiss

    public init(viewModel: PaywallViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    @ViewBuilder
    public var body: some View {
        NavigationStack {
            VStack(spacingSize: .xl) {
                switch (viewModel.isLoading, viewModel.isPremiumActive) {
                case (false, true):
                    VStack(spacingSize: .lg) {
                        AppearTransitionView(
                            transition: .scale(scale: 1, anchor: .center)
                                .combined(with: .opacity)
                        ) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 50))
                                .padding(.all, .lg)
                                .background(.ultraThinMaterial, in: RoundedHexagon(cornerSize: .lg))
                                .foregroundColor(.yellow)
                                .shadow(
                                    color: .white.opacity(0.2),
                                    radius: Size.lg.rawValue
                                )
                        }

                        Text("Premium Subscription Active")
                            .font(.plusJakartaSans(.title, weight: .bold))

                        if let renewalDate = viewModel.renewalDate {
                            Text(
                                "Your subscription renews on \(renewalDate.formatted(date: .long, time: .omitted))"
                            )
                            .font(.plusJakartaSans(.subheadline, weight: .semibold))
                        } else {
                            Text("Subscription details unavailable.")
                                .font(.plusJakartaSans(.subheadline, weight: .semibold))
                        }

                        Button(action: {
                            viewModel.openSubscriptionManagement()
                        }) {
                            Text("Manage Subscription")
                        }
                        .buttonStyle(ProminentButtonStyle())
                        .padding(.top, .sm)
                    }
                    .padding(.all, .lg)

                default:
                    ProgressView("Loading Subscription...")
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .foregroundStyle(.white)
                }

                // Restore purchases button
                Button(action: {
                    Task {
                        await viewModel.restorePurchases()
                    }
                }) {
                    Text("Restore Purchases")
                        .font(.plusJakartaSans(.subheadline))
                }
                .buttonStyle(TextButtonStyle(tintColor: .white))
                .disabled(viewModel.isRestoring)
            }
            .foregroundStyle(Color.white)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.all, .lg)
            .task {
                await viewModel.loadSubscriptionDetails()
            }
            .sheet(isPresented: $viewModel.showPaywallView) {
                PaywallView(
                    viewModel: PaywallViewModel(
                        dependencies: viewModel.dependencies
                    )
                )
            }
            .background {
                AppResourcesAsset.Assets.subscriptionManagementPattern.swiftUIImage
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    SubscriptionManagementView(
        viewModel:
        PaywallViewModel(
            dependencies: Dependencies()
        )
    )
}
