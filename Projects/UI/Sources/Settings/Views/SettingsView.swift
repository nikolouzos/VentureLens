import AppResources
import Core
import SwiftUI

public struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel
    @State private var showingLogoutAlert = false
    @State private var showingDeleteAccountAlert = false

    public init(
        viewModel: SettingsViewModel,
        showingLogoutAlert: Bool = false,
        showingDeleteAccountAlert: Bool = false
    ) {
        _viewModel = .init(wrappedValue: viewModel)
        self.showingLogoutAlert = showingLogoutAlert
        self.showingDeleteAccountAlert = showingDeleteAccountAlert
    }

    public var body: some View {
        NavigationView {
            Form {
                freeUnlockBannerView
                guestAccountBannerView

                Section {
                    Group {
                        if viewModel.isPremiumActive {
                            subscriptionManagementView
                        } else {
                            SubscriptionUpsellView(
                                viewModel: viewModel.paywallViewModel
                            )
                        }
                    }
                } header: {
                    Text("Subscription")
                }

                NavigationLink(
                    destination: ProfileView(
                        viewModel: ProfileViewModel(settingsViewModel: viewModel)
                    )
                    .navigationViewStyle(.stack)
                ) {
                    Label("Profile", systemImage: "person")
                }

//                Section(header: Text("Notifications")) {
//                    Toggle(isOn: viewModel.pushNotificationsToggle) {
//                        Label("Notifications", systemImage: "app.badge")
//                    }
//                }

                Section {
                    Toggle(isOn: $viewModel.dataSharingToggle) {
                        Label("Data Sharing", systemImage: "document.badge.arrow.up")
                    }
                    .onChange(of: viewModel.dataSharingToggle) { _, newValue in
                        viewModel.handleDataSharingChange(newValue)
                    }
                } header: {
                    Text("Privacy")
                } footer: {
                    Text("We use this data for improving our app experience. For more details, please check our Privacy Policy.")
                        .font(.plusJakartaSans(.subheadline))
                        .multilineTextAlignment(.center)
                        .padding(.top, .md)
                }

                Section {
                    Link(
                        "Terms of Service",
                        destination: viewModel.appMetadata.legalURLs.termsOfService
                    )
                    Link(
                        "Privacy Policy",
                        destination: viewModel.appMetadata.legalURLs.privacyPolicy
                    )
                }
                .buttonStyle(TextButtonStyle())

                Section {
                    Button("Logout") {
                        showingLogoutAlert = true
                    }
                    .buttonStyle(TextButtonStyle(tintColor: .themePrimary))
                    .alert(isPresented: $showingLogoutAlert) {
                        Alert(
                            title: Text("Logout"),
                            message: Text("Are you sure you want to logout?"),
                            primaryButton: .destructive(Text("Logout")) {
                                viewModel.logout()
                            },
                            secondaryButton: .cancel()
                        )
                    }

                    Button("Delete Account") {
                        showingDeleteAccountAlert = true
                    }
                    .buttonStyle(TextButtonStyle(tintColor: .themePrimary))
                    .alert(isPresented: $showingDeleteAccountAlert) {
                        Alert(
                            title: Text("Delete Account"),
                            message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                            primaryButton: .destructive(Text("Delete")) {
                                viewModel.deleteAccount()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }

                Section {
                    Text("App Version: \(viewModel.appMetadata.versionString)")
                        .font(.plusJakartaSans(.caption))
                        .foregroundStyle(Color.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                .padding(.bottom, .lg)
            }
            .navigationTitle("Settings")
        }
        .disabled(viewModel.isLoading)
        .task {
            await viewModel.getSettings()
        }
        .alert(
            isPresented: Binding(
                get: { viewModel.error != nil },
                set: { _ in viewModel.error = nil }
            )
        ) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.error?.localizedDescription ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    @ViewBuilder
    private var freeUnlockBannerView: some View {
        if !viewModel.isLoading,
           viewModel.user?.isAnonymous != true,
           viewModel.user?.subscription == .free
        {
            Section {
                FreeUnlockBannerView(
                    isAvailable: viewModel.freeUnlockAvailable,
                    nextUnlockDate: viewModel.nextUnlockDate
                )
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .padding(.top, .lg)
            }
        }
    }

    @ViewBuilder
    private var guestAccountBannerView: some View {
        if !viewModel.isLoading,
           viewModel.user?.isAnonymous == true
        {
            Section {
                GuestAccountBannerView()
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .padding(.top, .lg)
            }
        }
    }

    private var subscriptionManagementView: some View {
        HStack {
            VStack(alignment: .leading, spacingSize: .sm) {
                Text("Manage Subscription")

                Text("Premium Subscription Active")
                    .font(.plusJakartaSans(.footnote, weight: .medium))
                    .foregroundColor(.green)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.separator)
        }
        .onTapGesture {
            viewModel.showSubscriptionManagement()
        }
        .sheet(isPresented: $viewModel.showManagementView) {
            SubscriptionManagementView(viewModel: viewModel.paywallViewModel)
        }
    }
}

#if DEBUG
    import Dependencies
    import Networking

    #Preview {
        SettingsView(
            viewModel: SettingsViewModel(
                dependencies: Dependencies(),
                pushNotifications: PushNotifications(),
                coordinator: NavigationCoordinator()
            )
        )
        .navigationViewStyle(.stack)
    }
#endif
