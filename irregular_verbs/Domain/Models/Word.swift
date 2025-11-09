import Foundation

struct Word: Codable, Identifiable {
    let id: UUID
    let content: String
    let voiceUrl: String
    
    init(id: UUID = UUID(), content: String, voiceUrl: String) {
        self.id = id
        self.content = content
        self.voiceUrl = voiceUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
        case voiceUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID() // No id in JSON, create new UUID
        self.content = try container.decode(String.self, forKey: .content)
        self.voiceUrl = try container.decode(String.self, forKey: .voiceUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(content, forKey: .content)
        try container.encode(voiceUrl, forKey: .voiceUrl)
    }
}

