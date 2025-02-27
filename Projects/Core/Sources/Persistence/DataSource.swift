import Foundation
import SwiftData

@ModelActor
public actor DataSource<Model: PersistentModel>: Sendable {
    public init?(configurations: any DataStoreConfiguration...) {
        try? self.init(
            modelContainer: ModelContainer(
                for: Schema([Model.self]),
                configurations: configurations
            )
        )
    }

    public func fetch(
        descriptor: FetchDescriptor<Model> = FetchDescriptor()
    ) throws -> [Model] {
        if modelContext.hasChanges {
            modelContext.processPendingChanges()
        }

        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch data for model: \(Model.self)")
        }

        return []
    }
    
    public func fetchSingle(_ id: Model.ID) throws -> Model? {
        return try fetch().first { $0.id == id }
    }

    @discardableResult
    public func append(_ models: Model...) -> Bool {
        do {
            try modelContext.transaction {
                for model in models {
                    modelContext.insert(model)
                }

                if modelContext.hasChanges {
                    try modelContext.save()
                }
            }
        } catch {
            assertionFailure("Could not append data to \(Model.self)")
            return false
        }
        return true
    }

    public func delete(_ id: Model.ID) -> Bool {
        guard let model = try? fetchSingle(id) else {
            return false
        }
        
        modelContext.delete(model)
        do {
            try modelContext.save()
            return true
        } catch {
            return false
        }
    }

    public func delete(_ ids: [Model.ID]) -> Bool {
        do {
            var didDeleteAll = false

            try modelContext.transaction {
                didDeleteAll = !ids.map { delete($0) }.contains(false)

                if modelContext.hasChanges {
                    try modelContext.save()
                }
            }

            return didDeleteAll
        } catch {
            assertionFailure("Could not delete data (\(Model.self): \(error.localizedDescription)")
            return false
        }
    }
}
