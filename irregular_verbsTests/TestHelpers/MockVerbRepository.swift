import Foundation
@testable import irregular_verbs

// MARK: - Mock Repository for Testing

@MainActor
final class MockVerbRepository: VerbRepositoryProtocol {
    var verbsToReturn: [Verb] = []
    var errorToThrow: Error?
    var getAllVerbsCalled = false
    var isEmptyCalled = false
    var addVerbCalled = false
    var deleteVerbCalled = false
    var getVerbCalled = false
    var loadFromJSONCalled = false
    
    func isEmpty() -> Bool {
        isEmptyCalled = true
        return verbsToReturn.isEmpty
    }
    
    func loadFromJSONIfNeeded() async throws {
        loadFromJSONCalled = true
        if let error = errorToThrow {
            throw error
        }
    }
    
    func getAllVerbs() throws -> [Verb] {
        getAllVerbsCalled = true
        if let error = errorToThrow {
            throw error
        }
        return verbsToReturn
    }
    
    func getVerb(by id: UUID) throws -> Verb? {
        getVerbCalled = true
        if let error = errorToThrow {
            throw error
        }
        return verbsToReturn.first { $0.id == id }
    }
    
    func addVerb(_ verb: Verb) throws {
        addVerbCalled = true
        if let error = errorToThrow {
            throw error
        }
        verbsToReturn.append(verb)
    }
    
    func deleteVerb(_ verb: Verb) throws {
        deleteVerbCalled = true
        if let error = errorToThrow {
            throw error
        }
        verbsToReturn.removeAll { $0.id == verb.id }
    }
    
    func searchVerbs(query: String) throws -> [Verb] {
        if let error = errorToThrow {
            throw error
        }
        let lowercasedQuery = query.lowercased()
        return verbsToReturn.filter { verb in
            verb.original.content.lowercased().contains(lowercasedQuery) ||
            verb.simplePast.content.lowercased().contains(lowercasedQuery) ||
            verb.pastPerfect.content.lowercased().contains(lowercasedQuery) ||
            verb.translationList.contains { translation in
                translation.content.lowercased().contains(lowercasedQuery)
            }
        }
    }
    
    func getVerbsPaginated(offset: Int, limit: Int) throws -> [Verb] {
        if let error = errorToThrow {
            throw error
        }
        let endIndex = min(offset + limit, verbsToReturn.count)
        guard offset < verbsToReturn.count else {
            return []
        }
        return Array(verbsToReturn[offset..<endIndex])
    }
}

