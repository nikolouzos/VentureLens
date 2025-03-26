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
            .alert(isPresented: Binding(
                get: { viewModel.error != nil },
                set: { if !$0 { viewModel.error = nil } }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.error?.localizedDescription ?? "An unknown error occurred"),
                    dismissButton: .default(Text("OK"))
                )
            }
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
        VStack(spacing: 16) {
            Text("VentureLens would like to collect anonymous usage data to help us understand how you use the app and improve our features.")
                .multilineTextAlignment(.center)
            
            Text("This information is only used to improve the app and is never shared with third parties.")
                .multilineTextAlignment(.center)
            
            Text("You can change this setting anytime in the Privacy section of the Settings tab.")
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
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .font(.plusJakartaSans(.body, weight: .semibold))
                    .background(
                        RoundedRectangle(cornerSize: .sm)
                            .foregroundStyle(Color.themeSecondary)
                    )
                    .foregroundColor(.white)
            }
            
            Button {
                Task {
                    await viewModel.denyTracking()
                }
            } label: {
                Text("Don't Allow")
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .font(.plusJakartaSans(.body, weight: .semibold))
                    .foregroundColor(Color.themeSecondary)
                    .background(
                        RoundedRectangle(cornerSize: .sm)
                            .stroke(Color.themeSecondary, lineWidth: 1)
                    )
            }
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
                coordinator: NavigationCoordinator<AuthenticationViewState>()
            )
        )
    }
#endif 
