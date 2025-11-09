import Foundation

struct LoadVerbsFromJSONUseCase {
    let repository: VerbRepositoryProtocol
    
    func execute() async throws {
        try await repository.loadFromJSONIfNeeded()
    }
}

