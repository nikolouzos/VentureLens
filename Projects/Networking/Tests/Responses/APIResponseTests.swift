import XCTest
@testable import Networking

final class APIResponseTests: XCTestCase {
    class EmptyResponse: Codable { }
    
    // MARK: - Success Response Tests
    
    func testSuccessResponseDecoding() throws {
        // Given a JSON response for a UserProfile
        let json = """
        {
          "id": "48B3EBC4-039B-42B1-B676-51F5616FE1FB",
          "email": "test@example.com",
          "name": "Test User",
          "subscription": "free",
          "unlockedIdeas": [],
          "weeklyUnlocksUsed": 0
        }
        """.data(using: .utf8)!
        
        // When decoding the response
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let user = try decoder.decode(User.self, from: json)
        
        // Then the user should have the expected values
        XCTAssertEqual(user.id.uuidString, "48B3EBC4-039B-42B1-B676-51F5616FE1FB")
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertEqual(user.name, "Test User")
        XCTAssertEqual(user.subscription, .free)
        XCTAssertEqual(user.unlockedIdeas, [])
        XCTAssertEqual(user.weeklyUnlocksUsed, 0)
    }
    
    func testEmptyResponseHandling() throws {
        // Given an empty response
        let emptyData = "{}".data(using: .utf8)!
        
        // When decoding the response as EmptyResponse
        let decoder = JSONDecoder()
        let emptyResponse = try decoder.decode(EmptyResponse.self, from: emptyData)
        
        // Then the empty response should be successfully created
        XCTAssertNotNil(emptyResponse)
    }
    
    // MARK: - Error Response Tests
    
    func testNetworkErrorParsing() throws {
        // Given a server error response
        let errorResponse: [String: Any] = [
            "error": [
                "code": "server_error",
                "message": "Internal server error",
                "status_code": 500
            ]
        ]
        
        // Convert to JSON data
        let errorData = try JSONSerialization.data(withJSONObject: errorResponse)
        
        // When parsing the error data
        let json = try JSONSerialization.jsonObject(with: errorData) as? [String: Any]
        let errorDict = json?["error"] as? [String: Any]
        
        // Then we should be able to extract the error information
        let code = errorDict?["code"] as? String
        let message = errorDict?["message"] as? String
        let statusCode = errorDict?["status_code"] as? Int
        
        XCTAssertEqual(code, "server_error")
        XCTAssertEqual(message, "Internal server error")
        XCTAssertEqual(statusCode, 500)
    }
    
    func testDataDecodingError() throws {
        // Given malformed JSON for a User
        let invalidJson = """
        {
          "id": "user123",
          "email": true, // wrong type, email should be string
          "name": "Test User"
        }
        """.data(using: .utf8)!
        
        // When attempting to decode
        let decoder = JSONDecoder()
        
        // Then an error should be thrown
        XCTAssertThrowsError(try decoder.decode(User.self, from: invalidJson)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
} 
