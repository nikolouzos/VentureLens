import XCTest
import Supabase
@testable import Dependencies

final class SupabaseFilterBuilderConformanceTests: XCTestCase {
    
    private var filterBuilderProtocol: SupabaseFilterBuilderProtocol!
    
    override func setUp() {
        super.setUp()
        let supabaseClient = SupabaseClient(
            supabaseURL: URL(string: "https://example.supabase.co")!,
            supabaseKey: "test-key"
        )
        filterBuilderProtocol = supabaseClient.from("test_table").select("*")
    }
    
    override func tearDown() {
        filterBuilderProtocol = nil
        super.tearDown()
    }
    
    func testFilterBuilderConformsToProtocol() {
        XCTAssertTrue(filterBuilderProtocol is PostgrestFilterBuilder)
    }
    
    func testEqMethodReturnsFilterBuilder() {
        let result = filterBuilderProtocol.eq("id", value: "123")
        XCTAssertTrue(result is PostgrestFilterBuilder)
    }
    
    func testNeqMethodReturnsFilterBuilder() {
        let result = filterBuilderProtocol.neq("id", value: "123")
        XCTAssertTrue(result is PostgrestFilterBuilder)
    }
    
    func testGtMethodReturnsFilterBuilder() {
        let result = filterBuilderProtocol.gt("age", value: 18)
        XCTAssertTrue(result is PostgrestFilterBuilder)
    }
    
    func testLtMethodReturnsFilterBuilder() {
        let result = filterBuilderProtocol.lt("age", value: 65)
        XCTAssertTrue(result is PostgrestFilterBuilder)
    }
    
    func testGteMethodReturnsFilterBuilder() {
        let result = filterBuilderProtocol.gte("age", value: 18)
        XCTAssertTrue(result is PostgrestFilterBuilder)
    }
    
    func testLteMethodReturnsFilterBuilder() {
        let result = filterBuilderProtocol.lte("age", value: 65)
        XCTAssertTrue(result is PostgrestFilterBuilder)
    }
    
    func testLikeMethodReturnsFilterBuilder() {
        let result = filterBuilderProtocol.like("name", pattern: "%John%")
        XCTAssertTrue(result is PostgrestFilterBuilder)
    }
    
    func testInMethodReturnsFilterBuilder() {
        let result = filterBuilderProtocol.in("id", values: ["123", "456", "789"])
        XCTAssertTrue(result is PostgrestFilterBuilder)
    }
} 
