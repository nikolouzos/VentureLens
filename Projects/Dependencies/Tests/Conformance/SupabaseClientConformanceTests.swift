import XCTest
import Supabase
@testable import Dependencies

final class SupabaseClientConformanceTests: XCTestCase {
    
    // MARK: - Properties
    
    private var supabaseClientProtocol: SupabaseClientProtocol!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        // Create a test Supabase client with dummy credentials
        supabaseClientProtocol = SupabaseClient(
            supabaseURL: URL(string: "https://example.supabase.co")!,
            supabaseKey: "test-key"
        )
    }
    
    override func tearDown() {
        supabaseClientProtocol = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testSupabaseClientConformsToProtocol() {
        XCTAssertTrue(supabaseClientProtocol is SupabaseClient)
    }
    
    func testAuthMethodReturnsAuthClient() {
        let authClient = supabaseClientProtocol.auth()
        XCTAssertTrue(authClient is AuthClient)
    }
    
    func testFunctionsMethodReturnsFunctionsClient() {
        let functionsClient = supabaseClientProtocol.functions()
        XCTAssertTrue(functionsClient is FunctionsClient)
    }
    
    func testFromMethodReturnsPostgrestQueryBuilder() {
        let queryBuilder = supabaseClientProtocol.from("test_table")
        XCTAssertTrue(queryBuilder is PostgrestQueryBuilder)
    }
} 
