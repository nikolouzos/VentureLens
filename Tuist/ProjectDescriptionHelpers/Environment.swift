import ProjectDescription

public func supabaseUrl() -> String {
    if case let .string(supabaseUrl) = Environment.supabaseUrl {
        return supabaseUrl
    }
    print("TUIST_SUPABASE_URL not found in .env file. Returning mock value...")
    return "https://mock-supabase.co"
}

public func supabaseKey() -> String {
    if case let .string(supabaseKey) = Environment.supabaseKey {
        return supabaseKey
    }
    print("TUIST_SUPABASE_KEY not found in .env file. Returning mock value...")
    return "mock-supabase-key"
}

public func mixpanelToken() -> String {
    if case let .string(mixpanelToken) = Environment.mixpanelToken {
        return mixpanelToken
    }
    print("TUIST_MIXPANEL_TOKEN not found in .env file. Returning mock value...")
    return "mock-mixpanel-token"
}

public func revenueCatApiKey() -> String {
    if case let .string(revenueCatApiKey) = Environment.revenuecatApiKey {
        return revenueCatApiKey
    }
    print("TUIST_REVENUECAT_API_KEY not found in .env file. Returning mock value...")
    return "mock-revenuecat-api-key"
}
