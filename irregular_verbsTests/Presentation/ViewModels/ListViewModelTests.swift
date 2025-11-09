import XCTest
@testable import irregular_verbs

@MainActor
final class ListViewModelTests: XCTestCase {
    
    var sut: ListViewModel!
    var mockRepository: MockVerbRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockVerbRepository()
        let getAllVerbsUseCase = GetAllVerbsUseCase(repository: mockRepository)
        let searchVerbsUseCase = SearchVerbsUseCase(repository: mockRepository)
        let getVerbsPaginatedUseCase = GetVerbsPaginatedUseCase(repository: mockRepository)
        let audioPlayerService = AudioPlayerService()
        sut = ListViewModel(
            getAllVerbsUseCase: getAllVerbsUseCase,
            searchVerbsUseCase: searchVerbsUseCase,
            getVerbsPaginatedUseCase: getVerbsPaginatedUseCase,
            audioPlayerService: audioPlayerService
        )
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testLoadInitialVerbs_WhenUseCaseSucceeds_ShouldUpdateVerbs() {
        // Given
        let expectedVerbs = createMockVerbs()
        mockRepository.verbsToReturn = expectedVerbs
        
        // When
        sut.loadInitialVerbs()
        
        // Then
        XCTAssertEqual(sut.verbs.count, expectedVerbs.count)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }
    
    func testLoadInitialVerbs_WhenUseCaseFails_ShouldSetErrorMessage() {
        // Given
        let expectedError = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockRepository.errorToThrow = expectedError
        
        // When
        sut.loadInitialVerbs()
        
        // Then
        XCTAssertTrue(sut.verbs.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.errorMessage)
    }
    
    func testLoadInitialVerbs_WhenLoading_ShouldSetIsLoadingToTrueThenFalse() {
        // Given
        let expectedVerbs = createMockVerbs()
        mockRepository.verbsToReturn = expectedVerbs
        
        // When
        sut.loadInitialVerbs()
        
        // Then - isLoading should be false after completion
        XCTAssertFalse(sut.isLoading)
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

