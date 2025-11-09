import Foundation
import SwiftData

@MainActor
class VerbRepository: ObservableObject {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // Checks if the repository is empty
    func isEmpty() -> Bool {
        let descriptor = FetchDescriptor<VerbEntity>()
        do {
            let count = try modelContext.fetchCount(descriptor)
            return count == 0
        } catch {
            print("Error checking repository: \(error)")
            return true
        }
    }
    
    // Reads data from JSON and writes to SwiftData
    func loadFromJSONIfNeeded() async throws {
        // If repository is not empty, skip writing
        guard isEmpty() else {
            print("Repository already contains data, skipping JSON load")
            return
        }
        
        // Read JSON file
        guard let url = Bundle.main.url(forResource: "all", withExtension: "json", subdirectory: "Resources/verbs") else {
            throw VerbRepositoryError.jsonFileNotFound
        }
        
        let data = try Data(contentsOf: url)
        let verbs = try JSONDecoder().decode([Verb].self, from: data)
        
        // Convert to VerbEntity and save
        for verb in verbs {
            let verbEntity = VerbEntity(from: verb)
            modelContext.insert(verbEntity)
        }
        
        // Save changes
        try modelContext.save()
        print("Successfully loaded \(verbs.count) verbs from JSON")
    }
    
    // Get all verbs
    func getAllVerbs() throws -> [VerbEntity] {
        let descriptor = FetchDescriptor<VerbEntity>(
            sortBy: [SortDescriptor(\.original.content)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    // Get verb by ID
    func getVerb(by id: UUID) throws -> VerbEntity? {
        let descriptor = FetchDescriptor<VerbEntity>(
            predicate: #Predicate { $0.id == id }
        )
        return try modelContext.fetch(descriptor).first
    }
    
    // Add verb
    func addVerb(_ verb: Verb) throws {
        let verbEntity = VerbEntity(from: verb)
        modelContext.insert(verbEntity)
        try modelContext.save()
    }
    
    // Delete verb
    func deleteVerb(_ verbEntity: VerbEntity) throws {
        modelContext.delete(verbEntity)
        try modelContext.save()
    }
}

enum VerbRepositoryError: LocalizedError {
    case jsonFileNotFound
    
    var errorDescription: String? {
        switch self {
        case .jsonFileNotFound:
            return "JSON file not found"
        }
    }
}

