import XCTest
import Networking
@testable import Dependencies
@testable import DependenciesTestHelpers
@testable import Supabase

final class SupabaseFunctionsAdapterTests: XCTestCase {
    
    // MARK: - Properties
    
    private var mockFunctionsClient: MockSupabaseFunctionsClient!
    private var functionsAdapter: SupabaseFunctionsAdapter!
    private let accessToken = "test-access-token"
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        mockFunctionsClient = MockSupabaseFunctionsClient()
        functionsAdapter = SupabaseFunctionsAdapter(
            supabaseFunctions: mockFunctionsClient
        )
    }
    
    override func tearDown() {
        mockFunctionsClient = nil
        functionsAdapter = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testFetchIdeasFilters() async throws {
        // Configure mock to return test data
        let mockResponse = IdeasFiltersResponse(
            minDate: Date(timeIntervalSince1970: 1612137600),
            maxDate: Date(timeIntervalSince1970: 1643673600),
            categories: ["Technology", "Health", "Education"]
        )
        
        mockFunctionsClient.mockResponse = mockResponse
        
        // Fetch ideas filters
        let response: IdeasFiltersResponse = try await functionsAdapter.fetch(
            .ideasFilters,
            accessToken: accessToken
        )
        
        // Verify the mock was called correctly
        XCTAssertTrue(mockFunctionsClient.invokeCalled)
        XCTAssertEqual(mockFunctionsClient.lastFunctionNameUsed, "ideas-filters")
        
        // Verify the response was decoded correctly
        XCTAssertEqual(response.categories, ["Technology", "Health", "Education"])
    }
    
    func testFetchIdeasList() async throws {
        // Configure mock to return test data
        let mockIdea = Idea.mock
        let mockResponse = IdeasListResponse(
            ideas: [mockIdea, mockIdea, mockIdea],
            currentPage: 1,
            totalPages: 3
        )
        
        mockFunctionsClient.mockResponse = mockResponse
        
        let request = IdeasListRequest(
            page: 1,
            requestType: .filters(
                query: "test",
                category: "Technology",
                createdBefore: Date(timeIntervalSince1970: 1612137600).formatted(),
                createdAfter: Date(timeIntervalSince1970: 1643673600).formatted()
            )
        )
        
        // Fetch ideas list
        let response: IdeasListResponse = try await functionsAdapter.fetch(
            .ideasList(request),
            accessToken: accessToken
        )
        
        // Verify the mock was called correctly
        XCTAssertTrue(mockFunctionsClient.invokeCalled)
        XCTAssertEqual(mockFunctionsClient.lastFunctionNameUsed, "ideas-list")
        
        // Verify the response was decoded correctly
        XCTAssertEqual(response.ideas.count, 3)
        XCTAssertEqual(response.currentPage, 1)
        XCTAssertEqual(response.totalPages, 3)
    }
    
    func testFetchThrowsErrorWhenClientFails() async {
        // Configure mock to throw an error
        mockFunctionsClient.mockError = NSError(domain: "test", code: 1)
        
        // Attempt to fetch ideas filters
        do {
            let _: IdeasFiltersResponse = try await functionsAdapter.fetch(
                .ideasFilters,
                accessToken: accessToken
            )
            XCTFail("Expected fetch to throw an error")
        } catch {
            // Verify an error was thrown
            XCTAssertNotNil(error)
        }
    }
} 
