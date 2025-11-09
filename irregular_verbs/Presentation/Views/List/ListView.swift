import SwiftUI

struct ListView: View {
    @StateObject private var viewModel: ListViewModel
    @FocusState private var isSearchFocused: Bool
    
    init(viewModel: ListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            searchBar
            
            // Content
            if viewModel.isLoading && viewModel.verbs.isEmpty {
                Spacer()
                ProgressView()
                Spacer()
            } else if let errorMessage = viewModel.errorMessage, viewModel.verbs.isEmpty {
                Spacer()
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
                Spacer()
            } else {
                verbList
            }
        }
        .navigationTitle("List")
        .onAppear {
            viewModel.loadInitialVerbs()
        }
    }
    
    private var searchBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search verbs...", text: $viewModel.searchText)
                    .focused($isSearchFocused)
                    .onChange(of: viewModel.searchText) { _, newValue in
                        if newValue.isEmpty {
                            viewModel.clearSearch()
                        } else if newValue.count >= 2 {
                            // Debounce search
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                if viewModel.searchText == newValue {
                                    viewModel.performSearch()
                                }
                            }
                        }
                    }
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.clearSearch()
                        isSearchFocused = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var verbList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.verbs) { verb in
                    VerbCardView(verb: verb) { word in
                        viewModel.playAudio(for: word)
                    }
                    .onAppear {
                        // Load more when reaching near the end
                        if verb.id == viewModel.verbs.suffix(5).first?.id {
                            viewModel.loadMoreVerbs()
                        }
                    }
                }
                
                // Loading indicator for pagination
                if viewModel.isLoadingMore {
                    ProgressView()
                        .padding()
                }
                
                // End of list indicator
                if !viewModel.hasMoreData && !viewModel.isSearchMode && !viewModel.verbs.isEmpty {
                    Text("End of list")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    // Helper for previews - simple mock repository
    @MainActor
    final class PreviewMockVerbRepository: VerbRepositoryProtocol {
        var verbsToReturn: [Verb] = []
        func isEmpty() -> Bool { false }
        func loadFromJSONIfNeeded() async throws {}
        func getAllVerbs() throws -> [Verb] { verbsToReturn }
        func getVerb(by id: UUID) throws -> Verb? { verbsToReturn.first { $0.id == id } }
        func addVerb(_ verb: Verb) throws {}
        func deleteVerb(_ verb: Verb) throws {}
        func searchVerbs(query: String) throws -> [Verb] {
            let lowercasedQuery = query.lowercased()
            return verbsToReturn.filter { verb in
                verb.original.content.lowercased().contains(lowercasedQuery) ||
                verb.simplePast.content.lowercased().contains(lowercasedQuery) ||
                verb.pastPerfect.content.lowercased().contains(lowercasedQuery) ||
                verb.translationList.contains { translation in
                    translation.content.lowercased().contains(lowercasedQuery)
                }
            }
        }
        func getVerbsPaginated(offset: Int, limit: Int) throws -> [Verb] {
            let endIndex = min(offset + limit, verbsToReturn.count)
            guard offset < verbsToReturn.count else { return [] }
            return Array(verbsToReturn[offset..<endIndex])
        }
    }
    
    let mockRepository = PreviewMockVerbRepository()
    
    // Create sample verbs
    let verbs = (0..<25).map { index in
        let word1 = Word(content: "Verb\(index)", voiceUrl: "verb\(index).mp3")
        let word2 = Word(content: "Past\(index)", voiceUrl: "past\(index).mp3")
        let word3 = Word(content: "Perfect\(index)", voiceUrl: "perfect\(index).mp3")
        let translation = Translation(lang: "tr", content: "Fiil \(index)")
        return Verb(
            original: word1,
            simplePast: word2,
            pastPerfect: word3,
            translationList: [translation]
        )
    }
    
    mockRepository.verbsToReturn = verbs
    
    let getAllVerbsUseCase = GetAllVerbsUseCase(repository: mockRepository)
    let searchVerbsUseCase = SearchVerbsUseCase(repository: mockRepository)
    let getVerbsPaginatedUseCase = GetVerbsPaginatedUseCase(repository: mockRepository)
    let audioPlayerService = AudioPlayerService()
    
    let viewModel = ListViewModel(
        getAllVerbsUseCase: getAllVerbsUseCase,
        searchVerbsUseCase: searchVerbsUseCase,
        getVerbsPaginatedUseCase: getVerbsPaginatedUseCase,
        audioPlayerService: audioPlayerService
    )
    
    return NavigationStack {
        ListView(viewModel: viewModel)
    }
}
