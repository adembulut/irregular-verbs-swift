import XCTest
@testable import irregular_verbs

@MainActor
final class GetAllVerbsUseCaseTests: XCTestCase {
    
    // MARK: - Properties
    
    var sut: GetAllVerbsUseCase! // System Under Test
    var mockRepository: MockVerbRepository!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        mockRepository = MockVerbRepository()
        sut = GetAllVerbsUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testExecute_WhenRepositoryReturnsVerbs_ShouldReturnVerbs() throws {
        // Given (Arrange)
        let expectedVerbs = createMockVerbs()
        mockRepository.verbsToReturn = expectedVerbs
        
        // When (Act)
        let result = try sut.execute()
        
        // Then (Assert)
        XCTAssertEqual(result.count, expectedVerbs.count)
        XCTAssertEqual(result.first?.id, expectedVerbs.first?.id)
        XCTAssertTrue(mockRepository.getAllVerbsCalled)
    }
    
    func testExecute_WhenRepositoryThrowsError_ShouldPropagateError() {
        // Given
        let expectedError = NSError(domain: "TestError", code: 1)
        mockRepository.errorToThrow = expectedError
        
        // When & Then
        XCTAssertThrowsError(try sut.execute()) { error in
            XCTAssertEqual((error as NSError).code, expectedError.code)
        }
        XCTAssertTrue(mockRepository.getAllVerbsCalled)
    }
    
    func testExecute_WhenRepositoryReturnsEmpty_ShouldReturnEmptyArray() throws {
        // Given
        mockRepository.verbsToReturn = []
        
        // When
        let result = try sut.execute()
        
        // Then
        XCTAssertTrue(result.isEmpty)
        XCTAssertTrue(mockRepository.getAllVerbsCalled)
    }
    
    // MARK: - Helper Methods
    
    private func createMockVerbs() -> [Verb] {
        let word1 = Word(content: "Be", voiceUrl: "be.mp3")
        let word2 = Word(content: "Was", voiceUrl: "was.mp3")
        let word3 = Word(content: "Been", voiceUrl: "been.mp3")
        let translation = Translation(lang: "tr", content: "Olmak")
        
        let verb = Verb(
            original: word1,
            simplePast: word2,
            pastPerfect: word3,
            translationList: [translation]
        )
        
        return [verb]
    }
}


