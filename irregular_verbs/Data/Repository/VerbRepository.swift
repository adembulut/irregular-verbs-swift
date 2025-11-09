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
        
        // Try different possible paths for JSON file
        var url = Bundle.main.url(forResource: "all", withExtension: "json", subdirectory: "Resources/verbs")
        
        if url == nil {
            // Try without Resources prefix
            url = Bundle.main.url(forResource: "all", withExtension: "json", subdirectory: "verbs")
        }
        
        if url == nil {
            // Try in root
            url = Bundle.main.url(forResource: "all", withExtension: "json")
        }
        
        guard let jsonURL = url else {
            #if DEBUG
            // Debug: Print available bundle paths
            if let bundlePath = Bundle.main.resourcePath {
                print("Bundle resource path: \(bundlePath)")
                print("Available files in bundle:")
                if let files = try? FileManager.default.contentsOfDirectory(atPath: bundlePath) {
                    for file in files {
                        print("  - \(file)")
                    }
                }
            }
            #endif
            throw VerbRepositoryError.jsonFileNotFound
        }
        
        // Read and decode JSON on background thread to avoid blocking UI
        let verbs = try await Task.detached(priority: .userInitiated) {
            let data = try Data(contentsOf: jsonURL)
            return try JSONDecoder().decode([Verb].self, from: data)
        }.value
        
        // Insert verbs in batches to avoid blocking the main thread
        let batchSize = 20
        for (index, verb) in verbs.enumerated() {
            let verbEntity = VerbMapper.toEntity(verb)
            modelContext.insert(verbEntity)
            
            // Save every batchSize items and yield to main thread
            if (index + 1) % batchSize == 0 {
                try modelContext.save()
                // Yield to allow UI updates
                await Task.yield()
            }
        }
        
        // Final save for remaining items
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
    
    func searchVerbs(query: String) throws -> [Verb] {
        // SwiftData predicate limitations: fetch all and filter in memory
        // For better performance with large datasets, consider using full-text search
        let allEntities = try modelContext.fetch(
            FetchDescriptor<VerbEntity>(
                sortBy: [SortDescriptor(\.original.content)]
            )
        )
        
        let lowercasedQuery = query.lowercased()
        let filteredEntities = allEntities.filter { entity in
            entity.original.content.lowercased().contains(lowercasedQuery) ||
            entity.simplePast.content.lowercased().contains(lowercasedQuery) ||
            entity.pastPerfect.content.lowercased().contains(lowercasedQuery) ||
            entity.translations.contains { translation in
                translation.content.lowercased().contains(lowercasedQuery)
            }
        }
        
        return filteredEntities.map { VerbMapper.toDomain($0) }
    }
    
    func getVerbsPaginated(offset: Int, limit: Int) throws -> [Verb] {
        var descriptor = FetchDescriptor<VerbEntity>(
            sortBy: [SortDescriptor(\.original.content)]
        )
        descriptor.fetchOffset = offset
        descriptor.fetchLimit = limit
        let entities = try modelContext.fetch(descriptor)
        return entities.map { VerbMapper.toDomain($0) }
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
