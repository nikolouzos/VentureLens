import Foundation
import Mixpanel
import Networking
import Supabase

public class Dependencies {
    public let authentication: Authentication
    public let apiClient: APIClientProtocol
    public let analytics: Analytics

    public convenience init() {
        let supabaseClient = SupabaseClient(
            supabaseURL: URL(string: EnvironmentVariables.shared.get(key: .supabaseUrl)!)!,
            supabaseKey: EnvironmentVariables.shared.get(key: .supabaseKey)!
        )

        let analytics = Self.initializeAnalytics()

        self.init(
            authentication: ConcreteAuthentication(
                authClient: SupabaseAuthAdapter(
                    supabaseClient: supabaseClient
                )
            ),
            apiClient: SupabaseFunctionsAdapter(
                supabaseFunctions: supabaseClient.functions
            ),
            analytics: analytics
        )
    }

    public init(
        authentication: Authentication,
        apiClient: APIClientProtocol,
        analytics: Analytics
    ) {
        self.authentication = authentication
        self.apiClient = apiClient
        self.analytics = analytics
    }

    private class func initializeAnalytics() -> Analytics {
        let hasShownPermission = UserDefaults.standard.hasShownAnalyticsPermission

        // If permission has been shown, respect the user's choice
        // Otherwise default to opted out for privacy
        let shouldOptOut = hasShownPermission
            ? !UserDefaults.standard.isAnalyticsTrackingEnabled
            : true

        let mixpanelInstance = Mixpanel.initialize(
            token: EnvironmentVariables.shared.get(key: .mixpanelToken)!,
            trackAutomaticEvents: true,
            optOutTrackingByDefault: shouldOptOut,
            serverURL: "https://api-eu.mixpanel.com"
        )

        #if DEBUG
            mixpanelInstance.loggingEnabled = true
        #endif

        return mixpanelInstance
    }
}
