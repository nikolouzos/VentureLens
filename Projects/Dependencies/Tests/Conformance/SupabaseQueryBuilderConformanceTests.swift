import XCTest
import Supabase
@testable import Dependencies

final class SupabaseQueryBuilderConformanceTests: XCTestCase {
    
    private var queryBuilderProtocol: SupabaseQueryBuilderProtocol!
    
    override func setUp() {
        super.setUp()
        let supabaseClient = SupabaseClient(
            supabaseURL: URL(string: "https://example.supabase.co")!,
            supabaseKey: "test-key"
        )
        queryBuilderProtocol = supabaseClient.from("test_table") as PostgrestQueryBuilder
    }
    
    override func tearDown() {
        queryBuilderProtocol = nil
        super.tearDown()
    }
    
    func testQueryBuilderConformsToProtocol() {
        XCTAssertTrue(queryBuilderProtocol is PostgrestQueryBuilder)
    }
    
    func testSelectMethodReturnsFilterBuilder() {
        let filterBuilder = queryBuilderProtocol.select("*", head: false, count: nil)
        XCTAssertTrue(filterBuilder is PostgrestFilterBuilder)
    }
    
    func testSelectMethodWithColumnsReturnsFilterBuilder() {
        let filterBuilder = queryBuilderProtocol.select("id, name, email", head: false, count: nil)
        XCTAssertTrue(filterBuilder is PostgrestFilterBuilder)
    }
    
    func testSelectMethodWithHeadReturnsFilterBuilder() {
        let filterBuilder = queryBuilderProtocol.select("*", head: true, count: nil)
        XCTAssertTrue(filterBuilder is PostgrestFilterBuilder)
    }
    
    func testSelectMethodWithCountReturnsFilterBuilder() {
        let filterBuilder = queryBuilderProtocol.select("*", head: false, count: .exact)
        XCTAssertTrue(filterBuilder is PostgrestFilterBuilder)
    }
} 
