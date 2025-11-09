import Foundation

protocol VerbRepositoryProtocol {
    func isEmpty() -> Bool
    func loadFromJSONIfNeeded() async throws
    func getAllVerbs() throws -> [Verb]
    func getVerb(by id: UUID) throws -> Verb?
    func addVerb(_ verb: Verb) throws
    func deleteVerb(_ verb: Verb) throws
}

