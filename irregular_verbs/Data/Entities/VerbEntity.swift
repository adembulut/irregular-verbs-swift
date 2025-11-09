import Foundation
import SwiftData

@Model
final class VerbEntity {
    @Attribute(.unique) var id: UUID
    var original: WordEntity
    var simplePast: WordEntity
    var pastPerfect: WordEntity
    @Relationship(deleteRule: .cascade) var translations: [TranslationEntity]
    
    init(id: UUID = UUID(), original: WordEntity, simplePast: WordEntity, pastPerfect: WordEntity, translations: [TranslationEntity] = []) {
        self.id = id
        self.original = original
        self.simplePast = simplePast
        self.pastPerfect = pastPerfect
        self.translations = translations
    }
    
    // Convert from Codable Verb to VerbEntity
    convenience init(from verb: Verb) {
        let originalWord = WordEntity(from: verb.original)
        let simplePastWord = WordEntity(from: verb.simplePast)
        let pastPerfectWord = WordEntity(from: verb.pastPerfect)
        let translations = verb.translationList.map { TranslationEntity(from: $0) }
        
        self.init(
            id: verb.id,
            original: originalWord,
            simplePast: simplePastWord,
            pastPerfect: pastPerfectWord,
            translations: translations
        )
    }
    
    // Convert from VerbEntity to Codable Verb
    func toVerb() -> Verb {
        Verb(
            id: id,
            original: original.toWord(),
            simplePast: simplePast.toWord(),
            pastPerfect: pastPerfect.toWord(),
            translationList: translations.map { $0.toTranslation() }
        )
    }
}

