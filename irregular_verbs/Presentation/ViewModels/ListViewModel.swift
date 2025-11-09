import Foundation
import SwiftUI

@MainActor
final class ListViewModel: ObservableObject {
    @Published var verbs: [Verb] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let getAllVerbsUseCase: GetAllVerbsUseCase
    
    init(getAllVerbsUseCase: GetAllVerbsUseCase) {
        self.getAllVerbsUseCase = getAllVerbsUseCase
    }
    
    func loadVerbs() {
        isLoading = true
        errorMessage = nil
        
        do {
            verbs = try getAllVerbsUseCase.execute()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}

