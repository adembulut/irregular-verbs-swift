import Foundation

struct Verb: Codable, Identifiable {
    let id: UUID
    let original: Word
    let simplePast: Word
    let pastPerfect: Word
    let translationList: [Translation]
    
    init(id: UUID = UUID(), original: Word, simplePast: Word, pastPerfect: Word, translationList: [Translation]) {
        self.id = id
        self.original = original
        self.simplePast = simplePast
        self.pastPerfect = pastPerfect
        self.translationList = translationList
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case original
        case simplePast
        case pastPerfect
        case translationList
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID() // No id in JSON, create new UUID
        self.original = try container.decode(Word.self, forKey: .original)
        self.simplePast = try container.decode(Word.self, forKey: .simplePast)
        self.pastPerfect = try container.decode(Word.self, forKey: .pastPerfect)
        self.translationList = try container.decode([Translation].self, forKey: .translationList)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(original, forKey: .original)
        try container.encode(simplePast, forKey: .simplePast)
        try container.encode(pastPerfect, forKey: .pastPerfect)
        try container.encode(translationList, forKey: .translationList)
    }
    
    var turkishTranslation: String? {
        translationList.first(where: { $0.lang == "tr" })?.content
    }
}

