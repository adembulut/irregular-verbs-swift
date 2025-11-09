import Foundation

struct VerbMapper {
    static func toDomain(_ entity: VerbEntity) -> Verb {
        entity.toVerb()
    }
    
    static func toEntity(_ domain: Verb) -> VerbEntity {
        VerbEntity(from: domain)
    }
}

