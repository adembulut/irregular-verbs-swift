import Foundation

struct GetAllVerbsUseCase {
    let repository: VerbRepositoryProtocol
    
    func execute() throws -> [Verb] {
        try repository.getAllVerbs()
    }
}

