import XCTest
@testable import irregular_verbs

final class VerbTests: XCTestCase {
    
    func testTurkishTranslation_WhenTranslationExists_ShouldReturnTranslation() {
        // Given
        let word = Word(content: "Be", voiceUrl: "be.mp3")
        let translation = Translation(lang: "tr", content: "Olmak")
        let verb = Verb(
            original: word,
            simplePast: word,
            pastPerfect: word,
            translationList: [translation]
        )
        
        // When
        let result = verb.turkishTranslation
        
        // Then
        XCTAssertEqual(result, "Olmak")
    }
    
    func testTurkishTranslation_WhenTranslationDoesNotExist_ShouldReturnNil() {
        // Given
        let word = Word(content: "Be", voiceUrl: "be.mp3")
        let translation = Translation(lang: "en", content: "To be")
        let verb = Verb(
            original: word,
            simplePast: word,
            pastPerfect: word,
            translationList: [translation]
        )
        
        // When
        let result = verb.turkishTranslation
        
        // Then
        XCTAssertNil(result)
    }
    
    func testTurkishTranslation_WhenMultipleTranslationsExist_ShouldReturnFirstTurkish() {
        // Given
        let word = Word(content: "Be", voiceUrl: "be.mp3")
        let translation1 = Translation(lang: "en", content: "To be")
        let translation2 = Translation(lang: "tr", content: "Olmak")
        let translation3 = Translation(lang: "tr", content: "Var olmak")
        let verb = Verb(
            original: word,
            simplePast: word,
            pastPerfect: word,
            translationList: [translation1, translation2, translation3]
        )
        
        // When
        let result = verb.turkishTranslation
        
        // Then
        XCTAssertEqual(result, "Olmak") // First Turkish translation
    }
}

