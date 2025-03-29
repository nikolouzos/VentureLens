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
                if !viewModel.isLoading && viewModel.user?.subscription == .free {
                    Section {
                        FreeUnlockBannerView(
                            isAvailable: viewModel.freeUnlockAvailable,
                            nextUnlockDate: viewModel.nextUnlockDate
                        )
                    }
                    .frame(maxWidth: .infinity)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .padding(.top, .lg)
                }

                NavigationLink(
                    destination: ProfileView(
                        viewModel: ProfileViewModel(settingsViewModel: viewModel)
                    )
                    .navigationViewStyle(.stack)
                ) {
                    Label("Profile", systemImage: "person")
                }
                Section(header: Text("Notifications")) {
                    Toggle(isOn: viewModel.pushNotificationsToggle) {
                        Label("Notifications", systemImage: "app.badge")
                    }
                }

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
                    Link("Terms of Service", destination: viewModel.legalURLs.termsOfService)
                    Link("Privacy Policy", destination: viewModel.legalURLs.privacyPolicy)
                }

                Section {
                    Button("Logout") {
                        showingLogoutAlert = true
                    }
                    .foregroundStyle(Color.red)
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
                    .foregroundStyle(Color.red)
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
                    Text(viewModel.versionString)
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
}

#if DEBUG
    import Core
    import Dependencies
    import Networking

    #Preview {
        SettingsView(
            viewModel: SettingsViewModel(
                authentication: Dependencies().authentication,
                pushNotifications: PushNotifications(),
                coordinator: NavigationCoordinator(),
                analytics: Dependencies().analytics
            )
        )
        .navigationViewStyle(.stack)
    }
#endif
