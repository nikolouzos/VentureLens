import Foundation
import SwiftData
@testable import Networking

/// Helpers for testing SwiftData models
public enum SwiftDataHelpers {
    /// Creates a test ModelContainer with the given configurations
    /// - Parameters:
    ///   - schemas: The schemas to include in the container
    ///   - configurations: The configurations to use
    /// - Returns: A configured ModelContainer
    public static func createTestContainer<Model: PersistentModel>(
        for schemas: [Model.Type],
        configurations: [ModelConfiguration] = [ModelConfiguration(isStoredInMemoryOnly: true)]
    ) throws -> ModelContainer {
        let schema = Schema(schemas)
        
        return try ModelContainer(
            for: schema,
            configurations: configurations
        )
    }
    
    /// Creates a test ModelContext with the given schemas
    /// - Parameters:
    ///   - schemas: The schemas to include in the context
    ///   - isStoredInMemoryOnly: Whether the context should be in-memory only
    /// - Returns: A configured ModelContext
    public static func createTestContext<Model: PersistentModel>(
        for schemas: [Model.Type],
        isStoredInMemoryOnly: Bool = true
    ) throws -> ModelContext {
        let container = try createTestContainer(
            for: schemas,
            configurations: [ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)]
        )
        
        return ModelContext(container)
    }
    
    /// Creates a test ModelContext specifically for OAuthSignupData
    /// - Returns: A configured ModelContext for OAuthSignupData
    public static func createOAuthSignupDataContext() throws -> ModelContext {
        return try createTestContext(for: [OAuthSignupData.self])
    }
    
    /// Creates test OAuthSignupData instances in a ModelContext
    /// - Parameters:
    ///   - count: The number of instances to create
    ///   - context: The ModelContext to use
    /// - Returns: The created OAuthSignupData instances
    public static func createTestOAuthSignupData(
        count: Int = 3,
        in context: ModelContext? = nil
    ) throws -> [OAuthSignupData] {
        let ctx = try context ?? createOAuthSignupDataContext()
        
        var result: [OAuthSignupData] = []
        
        for i in 0..<count {
            let data = OAuthSignupData(
                email: "user\(i)@example.com",
                name: "Test User \(i)"
            )
            
            ctx.insert(data)
            result.append(data)
        }
        
        try ctx.save()
        return result
    }
    
    /// Deletes all instances of the given model type from a context
    /// - Parameters:
    ///   - type: The model type to delete
    ///   - context: The context to delete from
    public static func deleteAll<T: PersistentModel>(
        _ type: T.Type,
        from context: ModelContext
    ) throws {
        let fetchDescriptor = FetchDescriptor<T>()
        let items = try context.fetch(fetchDescriptor)
        
        for item in items {
            context.delete(item)
        }
        
        try context.save()
    }
}

/// Creates test OAuthSignupData instances
public enum OAuthSignupDataFixtures {
    /// Creates a basic OAuthSignupData instance
    /// - Parameters:
    ///   - email: The email to use
    ///   - name: The name to use
    /// - Returns: An OAuthSignupData instance
    public static func basic(
        email: String = "user@example.com", 
        name: String = "Test User"
    ) -> OAuthSignupData {
        return OAuthSignupData(email: email, name: name)
    }
    
    /// Creates an OAuthSignupData instance with only an email
    /// - Parameter email: The email to use
    /// - Returns: An OAuthSignupData instance
    public static func emailOnly(
        email: String = "emailonly@example.com"
    ) -> OAuthSignupData {
        return OAuthSignupData(email: email, name: "")
    }
    
    /// Creates an OAuthSignupData instance with only a name
    /// - Parameter name: The name to use
    /// - Returns: An OAuthSignupData instance
    public static func nameOnly(
        name: String = "Name Only User"
    ) -> OAuthSignupData {
        return OAuthSignupData(email: "", name: name)
    }
    
    /// Creates an empty OAuthSignupData instance
    /// - Returns: An OAuthSignupData instance
    public static func empty() -> OAuthSignupData {
        return OAuthSignupData(email: "", name: "")
    }
} 
