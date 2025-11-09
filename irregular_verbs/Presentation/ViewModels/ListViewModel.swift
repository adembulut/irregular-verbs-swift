import Foundation
import SwiftUI

@MainActor
final class ListViewModel: ObservableObject {
    @Published var verbs: [Verb] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var hasMoreData = true
    
    private let getAllVerbsUseCase: GetAllVerbsUseCase
    private let searchVerbsUseCase: SearchVerbsUseCase
    private let getVerbsPaginatedUseCase: GetVerbsPaginatedUseCase
    private let audioPlayerService: AudioPlayerService
    
    private let pageSize = 20
    private var currentPage = 0
    var isSearchMode = false
    
    init(
        getAllVerbsUseCase: GetAllVerbsUseCase,
        searchVerbsUseCase: SearchVerbsUseCase,
        getVerbsPaginatedUseCase: GetVerbsPaginatedUseCase,
        audioPlayerService: AudioPlayerService
    ) {
        self.getAllVerbsUseCase = getAllVerbsUseCase
        self.searchVerbsUseCase = searchVerbsUseCase
        self.getVerbsPaginatedUseCase = getVerbsPaginatedUseCase
        self.audioPlayerService = audioPlayerService
    }
    
    func loadInitialVerbs() {
        isLoading = true
        errorMessage = nil
        currentPage = 0
        isSearchMode = false
        hasMoreData = true
        
        do {
            let loadedVerbs = try getVerbsPaginatedUseCase.execute(page: currentPage, pageSize: pageSize)
            verbs = loadedVerbs
            hasMoreData = loadedVerbs.count == pageSize
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func loadMoreVerbs() {
        guard !isLoadingMore && hasMoreData && !isSearchMode else { return }
        
        isLoadingMore = true
        currentPage += 1
        
        do {
            let loadedVerbs = try getVerbsPaginatedUseCase.execute(page: currentPage, pageSize: pageSize)
            verbs.append(contentsOf: loadedVerbs)
            hasMoreData = loadedVerbs.count == pageSize
            isLoadingMore = false
        } catch {
            errorMessage = error.localizedDescription
            isLoadingMore = false
        }
    }
    
    func performSearch() {
        guard searchText.count >= 2 else {
            // Reset to pagination mode if search is too short
            if isSearchMode {
                clearSearch()
            }
            return
        }
        
        isLoading = true
        errorMessage = nil
        isSearchMode = true
        hasMoreData = false
        
        do {
            verbs = try searchVerbsUseCase.execute(query: searchText)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func clearSearch() {
        searchText = ""
        isSearchMode = false
        loadInitialVerbs()
    }
    
    func playAudio(for word: Word) {
        guard let mp3URL = word.mp3URL else {
            return
        }
        audioPlayerService.playAudio(from: mp3URL)
    }
    
    var audioPlayer: AudioPlayerService {
        audioPlayerService
    }
}
