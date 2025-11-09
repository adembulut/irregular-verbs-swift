import Foundation

struct Translation: Codable, Identifiable {
    let id: UUID
    let lang: String
    let content: String
    
    init(id: UUID = UUID(), lang: String, content: String) {
        self.id = id
        self.lang = lang
        self.content = content
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case lang
        case content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID() // No id in JSON, create new UUID
        self.lang = try container.decode(String.self, forKey: .lang)
        self.content = try container.decode(String.self, forKey: .content)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lang, forKey: .lang)
        try container.encode(content, forKey: .content)
    }
}

