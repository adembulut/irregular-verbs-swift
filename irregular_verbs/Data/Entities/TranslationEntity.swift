import Foundation
import SwiftData

@Model
final class TranslationEntity {
    @Attribute(.unique) var id: UUID
    var lang: String
    var content: String
    
    init(id: UUID = UUID(), lang: String, content: String) {
        self.id = id
        self.lang = lang
        self.content = content
    }
    
    // Convert from Codable Translation to TranslationEntity
    convenience init(from translation: Translation) {
        self.init(id: translation.id, lang: translation.lang, content: translation.content)
    }
    
    // Convert from TranslationEntity to Codable Translation
    func toTranslation() -> Translation {
        Translation(id: id, lang: lang, content: content)
    }
}

