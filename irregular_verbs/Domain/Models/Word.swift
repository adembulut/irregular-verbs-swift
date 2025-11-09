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
    
    // Get MP3 file name from voiceUrl (voiceUrl is already just the filename)
    var mp3FileName: String {
        voiceUrl
    }
    
    // Get MP3 URL from bundle
    var mp3URL: URL? {
        // Try direct path first (most reliable)
        if let resourcePath = Bundle.main.resourcePath {
            let filePath = "\(resourcePath)/Resources/verbs/mp3/\(mp3FileName)"
            if FileManager.default.fileExists(atPath: filePath) {
                return URL(fileURLWithPath: filePath)
            }
        }
        
        // Try with subdirectory
        let nameWithoutExtension = mp3FileName.replacingOccurrences(of: ".mp3", with: "")
        if let url = Bundle.main.url(forResource: nameWithoutExtension, 
                                     withExtension: "mp3", 
                                     subdirectory: "Resources/verbs/mp3") {
            return url
        }
        
        // Try without Resources prefix
        if let url = Bundle.main.url(forResource: nameWithoutExtension, 
                                     withExtension: "mp3", 
                                     subdirectory: "verbs/mp3") {
            return url
        }
        
        // Try at root of bundle
        if let url = Bundle.main.url(forResource: nameWithoutExtension, 
                                     withExtension: "mp3") {
            return url
        }
        
        return nil
    }
}

