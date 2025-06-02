import Core
import Dependencies
import SwiftUI

public struct AnalyticsPermissionView: View {
    @StateObject private var viewModel: AnalyticsPermissionViewModel

    public init(viewModel: AnalyticsPermissionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            VStack(spacingSize: .xl) {
                headerView
                Spacer()
                descriptionView
                Spacer()
                buttonStack
            }
            .padding(.horizontal, .lg)
            .padding(.vertical, .xl)
            .navigationBarTitleDisplayMode(.large)
            .disabled(viewModel.isLoading)
        }
    }

    private var headerView: some View {
        VStack(spacingSize: .lg) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 48))
                .foregroundStyle(Color.tint)
                .padding(.bottom, .sm)

            Text("Help us improve your experience")
                .font(.plusJakartaSans(.largeTitle, weight: .bold))
        }
    }

    private var descriptionView: some View {
        VStack(spacingSize: .lg) {
            Text("To enhance your app experience and improve our features, VentureLens collects data about your app usage, linked to your User ID and Email address (for account purposes).")
                .multilineTextAlignment(.center)

            Text("This information is used internally to analyze performance and optimize functionality. It is NOT used for advertising, cross-app tracking, or shared with data brokers.")
                .multilineTextAlignment(.center)

            Text("You can review or change your privacy settings anytime in the app's 'Privacy Settings'.")
                .multilineTextAlignment(.center)
                .font(.plusJakartaSans(.callout))
                .foregroundStyle(Color.secondary)
        }
    }

    private var buttonStack: some View {
        VStack(spacingSize: .lg) {
            Button {
                Task {
                    await viewModel.allowTracking()
                }
            } label: {
                Text("Allow Analytics")
            }
            .buttonStyle(
                ProminentButtonStyle(fullWidth: true)
            )

            Button {
                Task {
                    await viewModel.denyTracking()
                }
            } label: {
                Text("Don't Allow")
            }
            .buttonStyle(
                OutlineButtonStyle(fullWidth: true)
            )
        }
    }
}

#if DEBUG
    #Preview {
        let dependencies = Dependencies()

        AnalyticsPermissionView(
            viewModel: AnalyticsPermissionViewModel(
                analytics: dependencies.analytics,
                authentication: dependencies.authentication,
                coordinator: NavigationCoordinator()
            )
        )
    }
#endif
