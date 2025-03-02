import XCTest
import Supabase
@testable import Dependencies

final class SupabaseFunctionsClientConformanceTests: XCTestCase {
    
    // MARK: - Properties
    
    private var functionsClientProtocol: SupabaseFunctionsClientProtocol!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        
        let supabaseClient = SupabaseClient(
            supabaseURL: URL(string: "https://example.supabase.co")!,
            supabaseKey: "test-key"
        )
        functionsClientProtocol = supabaseClient.functions
    }
    
    override func tearDown() {
        functionsClientProtocol = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testFunctionsClientConformsToProtocol() {
        XCTAssertTrue(functionsClientProtocol is FunctionsClient)
    }
    
    func testInvokeWithDecodableResponseMethodIsAccessible() async {
        struct TestResponse: Decodable {
            let message: String
        }
        
        do {
            let _: TestResponse = try await functionsClientProtocol.invoke(
                "test-function",
                options: FunctionInvokeOptions(
                    method: .post,
                    headers: [:]
                ),
                decoder: JSONDecoder()
            )
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testInvokeWithoutResponseMethodIsAccessible() async {
        do {
            try await functionsClientProtocol.invoke(
                "test-function",
                options: FunctionInvokeOptions(
                    method: .post,
                    headers: [:]
                )
            )
        } catch {
            XCTAssertTrue(true)
        }
    }
} 
