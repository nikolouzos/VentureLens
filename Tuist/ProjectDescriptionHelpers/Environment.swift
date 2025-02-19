import ProjectDescription

public func supabaseUrl() -> String {
    if case let .string(supabaseUrl) = Environment.supabaseUrl {
        return supabaseUrl
    }
    fatalError("TUIST_SUPABASE_URL not found in .env file")
}

public func supabaseKey() -> String {
    if case let .string(supabaseKey) = Environment.supabaseKey {
        return supabaseKey
    }
    fatalError("TUIST_SUPABASE_KEY not found in .env file")
}
