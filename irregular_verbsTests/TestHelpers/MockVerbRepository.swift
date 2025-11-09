import Foundation
@testable import irregular_verbs

// MARK: - Mock Repository for Testing

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
}

