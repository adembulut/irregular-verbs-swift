import Foundation
import SwiftData

@Model
final class WordEntity {
    @Attribute(.unique) var id: UUID
    var content: String
    var voiceUrl: String
    
    init(id: UUID = UUID(), content: String, voiceUrl: String) {
        self.id = id
        self.content = content
        self.voiceUrl = voiceUrl
    }
    
    // Convert from Codable Word to WordEntity
    convenience init(from word: Word) {
        self.init(id: word.id, content: word.content, voiceUrl: word.voiceUrl)
    }
    
    // Convert from WordEntity to Codable Word
    func toWord() -> Word {
        Word(id: id, content: content, voiceUrl: voiceUrl)
    }
}

