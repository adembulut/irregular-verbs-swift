import Foundation

struct GetVerbsPaginatedUseCase {
    let repository: VerbRepositoryProtocol
    
    @MainActor
    func execute(page: Int, pageSize: Int) throws -> [Verb] {
        let offset = page * pageSize
        return try repository.getVerbsPaginated(offset: offset, limit: pageSize)
    }
}

