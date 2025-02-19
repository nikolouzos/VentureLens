import Foundation
import SwiftData

@ModelActor
actor DataSource<Model: PersistentModel>: Sendable {
    init?() {
        try? self.init(modelContainer: ModelContainer(for: Model.self))
    }

    func fetch(
        descriptor: FetchDescriptor<Model> = FetchDescriptor()
    ) async throws -> [Model] {
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

    @discardableResult
    func append(_ models: Model...) -> Bool {
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

    func delete(_ id: PersistentIdentifier) -> Bool {
        let model = modelContext.model(for: id)
        modelContext.delete(model)

        return true
    }

    func delete(_ ids: [PersistentIdentifier]) -> Bool {
        do {
            var didDeleteAll = false

            try modelContext.transaction {
                didDeleteAll = !ids
                    .map { delete($0) }
                    .contains(false)

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
