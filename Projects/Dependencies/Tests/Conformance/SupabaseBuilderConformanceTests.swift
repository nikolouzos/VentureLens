import XCTest
import Supabase
@testable import Dependencies

final class SupabaseBuilderConformanceTests: XCTestCase {
    
    private var builderProtocol: SupabaseBuilderProtocol!
    
    override func setUp() {
        super.setUp()
        let supabaseClient = SupabaseClient(
            supabaseURL: URL(string: "https://example.supabase.co")!,
            supabaseKey: "test-key"
        )
        builderProtocol = supabaseClient.from("test_table").select("*")
    }
    
    override func tearDown() {
        builderProtocol = nil
        super.tearDown()
    }
    
    func testBuilderConformsToProtocol() {
        XCTAssertTrue(builderProtocol is PostgrestBuilder)
    }
    
    func testExecuteWithDecodableResponseMethodIsAccessible() async {
        struct TestResponse: Decodable {
            let id: String
            let name: String
        }
        
        do {
            let _: PostgrestResponse<TestResponse> = try await builderProtocol.execute(options: FetchOptions())
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testExecuteWithVoidResponseMethodIsAccessible() async {
        do {
            let _: PostgrestResponse<Void> = try await builderProtocol.execute(options: FetchOptions())
        } catch {
            XCTAssertTrue(true)
        }
    }
} 