import XCTest
import Supabase
@testable import Dependencies

final class SupabaseTransformBuilderConformanceTests: XCTestCase {
    
    private var transformBuilderProtocol: SupabaseTransformBuilderProtocol!
    
    override func setUp() {
        super.setUp()
        let supabaseClient = SupabaseClient(
            supabaseURL: URL(string: "https://example.supabase.co")!,
            supabaseKey: "test-key"
        )
        transformBuilderProtocol = supabaseClient.from("test_table").select("*")
    }
    
    override func tearDown() {
        transformBuilderProtocol = nil
        super.tearDown()
    }
    
    func testTransformBuilderConformsToProtocol() {
        XCTAssertTrue(transformBuilderProtocol is PostgrestTransformBuilder)
    }
    
    func testSingleMethodReturnsTransformBuilder() {
        let result = transformBuilderProtocol.single()
        XCTAssertTrue(result is PostgrestTransformBuilder)
    }
    
    func testOrderMethodReturnsTransformBuilder() {
        let result = transformBuilderProtocol.order(
            "created_at",
            ascending: false,
            nullsFirst: false,
            referencedTable: nil
        )
        XCTAssertTrue(result is PostgrestTransformBuilder)
    }
    
    func testOrderMethodWithReferencedTableReturnsTransformBuilder() {
        let result = transformBuilderProtocol.order(
            "users.created_at",
            ascending: false,
            nullsFirst: false,
            referencedTable: "users"
        )
        XCTAssertTrue(result is PostgrestTransformBuilder)
    }
    
    func testLimitMethodReturnsTransformBuilder() {
        let result = transformBuilderProtocol.limit(10, referencedTable: nil)
        XCTAssertTrue(result is PostgrestTransformBuilder)
    }
    
    func testLimitMethodWithReferencedTableReturnsTransformBuilder() {
        let result = transformBuilderProtocol.limit(10, referencedTable: "users")
        XCTAssertTrue(result is PostgrestTransformBuilder)
    }
} 
