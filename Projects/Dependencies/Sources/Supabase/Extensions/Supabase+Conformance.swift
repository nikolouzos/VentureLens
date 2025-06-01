import Supabase

// MARK: - Extensions to make Supabase classes conform to our protocols

extension Supabase.SupabaseClient: SupabaseClientProtocol {
    public func auth() -> any SupabaseAuthClientProtocol {
        auth
    }

    public func functions() -> SupabaseFunctionsClientProtocol {
        functions
    }

    public func from(_ table: String) -> SupabaseQueryBuilderProtocol {
        from(table) as PostgrestQueryBuilder
    }
}

extension Supabase.AuthClient: SupabaseAuthClientProtocol {
    public var user: Supabase.User {
        get async throws {
            try await self.user(jwt: nil)
        }
    }

    public func signInAnonymously() async throws {
        try await signInAnonymously(data: nil)
    }

    public func signInWithOTP(email: String) async throws {
        try await signInWithOTP(
            email: email,
            redirectTo: nil,
            shouldCreateUser: true,
            data: nil,
            captchaToken: nil
        )
    }

    public func verifyOTP(email: String, token: String, type: Auth.EmailOTPType) async throws {
        try await verifyOTP(
            email: email,
            token: token,
            type: type,
            redirectTo: nil,
            captchaToken: nil
        )
    }

    public func signOut() async throws {
        try await signOut(scope: .global)
    }

    public func refreshSession() async throws {
        try await refreshSession(refreshToken: nil)
    }

    public func update(user: Auth.UserAttributes) async throws {
        try await update(user: user, redirectTo: nil)
    }
}

extension Supabase.FunctionsClient: SupabaseFunctionsClientProtocol {}

extension Supabase.PostgrestQueryBuilder: SupabaseQueryBuilderProtocol {
    public func select(_ columns: String, head: Bool, count: CountOption?) -> SupabaseFilterBuilderProtocol {
        select(columns, head: head, count: count) as PostgrestFilterBuilder
    }
}

extension Supabase.PostgrestFilterBuilder: SupabaseFilterBuilderProtocol {
    public func eq(_ column: String, value: Supabase.PostgrestFilterValue) -> SupabaseFilterBuilderProtocol {
        eq(column, value: value) as PostgrestFilterBuilder
    }

    public func neq(_ column: String, value: Supabase.PostgrestFilterValue) -> SupabaseFilterBuilderProtocol {
        neq(column, value: value) as PostgrestFilterBuilder
    }

    public func gt(_ column: String, value: Supabase.PostgrestFilterValue) -> SupabaseFilterBuilderProtocol {
        gt(column, value: value) as PostgrestFilterBuilder
    }

    public func lt(_ column: String, value: Supabase.PostgrestFilterValue) -> SupabaseFilterBuilderProtocol {
        lt(column, value: value) as PostgrestFilterBuilder
    }

    public func gte(_ column: String, value: Supabase.PostgrestFilterValue) -> SupabaseFilterBuilderProtocol {
        gte(column, value: value) as PostgrestFilterBuilder
    }

    public func lte(_ column: String, value: Supabase.PostgrestFilterValue) -> SupabaseFilterBuilderProtocol {
        lte(column, value: value) as PostgrestFilterBuilder
    }

    public func like(_ column: String, pattern: Supabase.PostgrestFilterValue) -> SupabaseFilterBuilderProtocol {
        like(column, pattern: pattern) as PostgrestFilterBuilder
    }

    public func `in`(_ column: String, values: [Supabase.PostgrestFilterValue]) -> SupabaseFilterBuilderProtocol {
        self.in(column, values: values) as PostgrestFilterBuilder
    }
}

extension Supabase.PostgrestTransformBuilder: SupabaseTransformBuilderProtocol {
    public func single() -> SupabaseTransformBuilderProtocol {
        single() as PostgrestTransformBuilder
    }

    public func order(
        _ column: String,
        ascending: Bool,
        nullsFirst: Bool,
        referencedTable: String?
    ) -> SupabaseTransformBuilderProtocol {
        order(
            column,
            ascending: ascending,
            nullsFirst: nullsFirst,
            referencedTable: referencedTable
        ) as PostgrestTransformBuilder
    }

    public func limit(_ count: Int, referencedTable: String?) -> SupabaseTransformBuilderProtocol {
        limit(count, referencedTable: referencedTable) as PostgrestTransformBuilder
    }
}

extension Supabase.PostgrestBuilder: SupabaseBuilderProtocol {}
