import XCTest
@testable import Networking

final class AuthenticationProviderTests: XCTestCase {
    func testOTPProvider() {
        // Given
        let email = "test@example.com"
        
        // When
        let provider = AuthenticationProvider.otp(email: email)
        
        // Then
        switch provider {
        case .otp(let providerEmail):
            XCTAssertEqual(providerEmail, email)
        default:
            XCTFail("Provider should be OTP")
        }
    }
    
    func testAppleProviderWithoutSignupData() {
        // Given
        let identityToken = "apple-identity-token"
        
        // When
        let provider = AuthenticationProvider.apple(identityToken: identityToken)
        
        // Then
        switch provider {
        case .apple(let token, let signupData):
            XCTAssertEqual(token, identityToken)
            XCTAssertNil(signupData)
        default:
            XCTFail("Provider should be Apple")
        }
    }
    
    func testAppleProviderWithSignupData() {
        // Given
        let identityToken = "apple-identity-token"
        let email = "apple-user@example.com"
        let name = "Apple User"
        let signupData = OAuthSignupData(email: email, name: name)
        
        // When
        let provider = AuthenticationProvider.apple(
            identityToken: identityToken,
            signupData: signupData
        )
        
        // Then
        switch provider {
        case .apple(let token, let data):
            XCTAssertEqual(token, identityToken)
            XCTAssertNotNil(data)
            XCTAssertEqual(data?.email, email)
            XCTAssertEqual(data?.name, name)
        default:
            XCTFail("Provider should be Apple")
        }
    }
    
    func testOAuthSignupData() {
        // Given
        let email = "user@example.com"
        let name = "Test User"
        
        // When
        let signupData = OAuthSignupData(email: email, name: name)
        
        // Then
        XCTAssertEqual(signupData.email, email)
        XCTAssertEqual(signupData.name, name)
    }
    
    func testOAuthSignupDataWithNilValues() {
        // Given & When
        let signupData = OAuthSignupData(email: nil, name: nil)
        
        // Then
        XCTAssertNil(signupData.email)
        XCTAssertNil(signupData.name)
    }
    
    func testProviderEquality() {
        // Test that providers with the same values are equal
        
        // Given
        let email = "test@example.com"
        let otp1 = AuthenticationProvider.otp(email: email)
        let otp2 = AuthenticationProvider.otp(email: email)
        
        let token = "apple-token"
        let apple1 = AuthenticationProvider.apple(identityToken: token)
        let apple2 = AuthenticationProvider.apple(identityToken: token)
        
        // Then
        XCTAssertEqual(otp1, otp2)
        XCTAssertEqual(apple1, apple2)
        XCTAssertNotEqual(otp1, apple1)
    }
} 
