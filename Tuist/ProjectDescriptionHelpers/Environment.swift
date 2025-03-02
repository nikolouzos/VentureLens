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
