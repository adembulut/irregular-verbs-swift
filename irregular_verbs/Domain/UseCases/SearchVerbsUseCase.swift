import Foundation

struct SearchVerbsUseCase {
    let repository: VerbRepositoryProtocol
    
    @MainActor
    func execute(query: String) throws -> [Verb] {
        guard query.count >= 2 else {
            return []
        }
        return try repository.searchVerbs(query: query)
    }
}

