import XCTest
@testable import irregular_verbs

@MainActor
final class ListViewModelTests: XCTestCase {
    
    var sut: ListViewModel!
    var mockRepository: MockVerbRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockVerbRepository()
        let useCase = GetAllVerbsUseCase(repository: mockRepository)
        sut = ListViewModel(getAllVerbsUseCase: useCase)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testLoadVerbs_WhenUseCaseSucceeds_ShouldUpdateVerbs() {
        // Given
        let expectedVerbs = createMockVerbs()
        mockRepository.verbsToReturn = expectedVerbs
        
        // When
        sut.loadVerbs()
        
        // Then
        XCTAssertEqual(sut.verbs.count, expectedVerbs.count)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertTrue(mockRepository.getAllVerbsCalled)
    }
    
    func testLoadVerbs_WhenUseCaseFails_ShouldSetErrorMessage() {
        // Given
        let expectedError = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockRepository.errorToThrow = expectedError
        
        // When
        sut.loadVerbs()
        
        // Then
        XCTAssertTrue(sut.verbs.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(mockRepository.getAllVerbsCalled)
    }
    
    func testLoadVerbs_WhenLoading_ShouldSetIsLoadingToTrueThenFalse() {
        // Given
        let expectedVerbs = createMockVerbs()
        mockRepository.verbsToReturn = expectedVerbs
        
        // When
        sut.loadVerbs()
        
        // Then - isLoading should be false after completion
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(mockRepository.getAllVerbsCalled)
    }
    
    // MARK: - Helper Methods
    
    private func createMockVerbs() -> [Verb] {
        let word = Word(content: "Be", voiceUrl: "be.mp3")
        let translation = Translation(lang: "tr", content: "Olmak")
        let verb = Verb(
            original: word,
            simplePast: word,
            pastPerfect: word,
            translationList: [translation]
        )
        return [verb]
    }
}

