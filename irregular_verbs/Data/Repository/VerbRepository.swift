import Foundation
import SwiftData

@MainActor
final class VerbRepository: VerbRepositoryProtocol, ObservableObject {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - VerbRepositoryProtocol
    
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
    
    func loadFromJSONIfNeeded() async throws {
        guard isEmpty() else {
            print("Repository already contains data, skipping JSON load")
            return
        }
        
        guard let url = Bundle.main.url(forResource: "all", withExtension: "json", subdirectory: "Resources/verbs") else {
            throw VerbRepositoryError.jsonFileNotFound
        }
        
        let data = try Data(contentsOf: url)
        let verbs = try JSONDecoder().decode([Verb].self, from: data)
        
        for verb in verbs {
            let verbEntity = VerbMapper.toEntity(verb)
            modelContext.insert(verbEntity)
        }
        
        try modelContext.save()
        print("Successfully loaded \(verbs.count) verbs from JSON")
    }
    
    func getAllVerbs() throws -> [Verb] {
        let descriptor = FetchDescriptor<VerbEntity>(
            sortBy: [SortDescriptor(\.original.content)]
        )
        let entities = try modelContext.fetch(descriptor)
        return entities.map { VerbMapper.toDomain($0) }
    }
    
    func getVerb(by id: UUID) throws -> Verb? {
        let descriptor = FetchDescriptor<VerbEntity>(
            predicate: #Predicate { $0.id == id }
        )
        guard let entity = try modelContext.fetch(descriptor).first else {
            return nil
        }
        return VerbMapper.toDomain(entity)
    }
    
    func addVerb(_ verb: Verb) throws {
        let verbEntity = VerbMapper.toEntity(verb)
        modelContext.insert(verbEntity)
        try modelContext.save()
    }
    
    func deleteVerb(_ verb: Verb) throws {
        let descriptor = FetchDescriptor<VerbEntity>(
            predicate: #Predicate { $0.id == verb.id }
        )
        guard let entity = try modelContext.fetch(descriptor).first else {
            return
        }
        modelContext.delete(entity)
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
