import Core
import Dependencies
import SwiftUI

public struct SubscriptionUpsellView: View {
    @ObservedObject var viewModel: PaywallViewModel

    public var body: some View {
        VStack(alignment: .center, spacingSize: .md) {
            Text("Unlock Premium Features")
                .font(.plusJakartaSans(.title2, weight: .bold))

            Text("Get unlimited ideas, advanced categories, and more!")
                .multilineTextAlignment(.center)

            Spacer()

            Button(action: viewModel.showPaywall) {
                Text("View Premium Plans")
            }
            .buttonStyle(ProminentButtonStyle())
        }
        .padding(.vertical, .md)
        .frame(maxWidth: .infinity)
        .font(.plusJakartaSans(.body, weight: .medium))
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.showPaywall()
        }
        .sheet(isPresented: $viewModel.showPaywallView) {
            PaywallView(viewModel: viewModel)
        }
    }
}

#Preview {
    SubscriptionUpsellView(
        viewModel: PaywallViewModel(
            dependencies: Dependencies()
        )
    )
}
