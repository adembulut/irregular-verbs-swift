import Foundation

struct GetAllVerbsUseCase {
    let repository: VerbRepositoryProtocol
    
    @MainActor
    func execute() throws -> [Verb] {
        try repository.getAllVerbs()
    }
}

