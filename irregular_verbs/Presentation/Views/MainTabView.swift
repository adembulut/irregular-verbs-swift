import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabView {
            makeListView()
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
            
            // Dummy tab - Study
            Text("Study")
                .tabItem {
                    Label("Study", systemImage: "book.fill")
                }
            
            // Dummy tab - Practice
            Text("Practice")
                .tabItem {
                    Label("Practice", systemImage: "pencil.and.list.clipboard")
                }
            
            // Dummy tab - Settings
            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
    
    private func makeListView() -> some View {
        let repository = VerbRepository(modelContext: modelContext)
        let getAllVerbsUseCase = GetAllVerbsUseCase(repository: repository)
        let searchVerbsUseCase = SearchVerbsUseCase(repository: repository)
        let getVerbsPaginatedUseCase = GetVerbsPaginatedUseCase(repository: repository)
        let audioPlayerService = AudioPlayerService()
        
        let viewModel = ListViewModel(
            getAllVerbsUseCase: getAllVerbsUseCase,
            searchVerbsUseCase: searchVerbsUseCase,
            getVerbsPaginatedUseCase: getVerbsPaginatedUseCase,
            audioPlayerService: audioPlayerService
        )
        return ListView(viewModel: viewModel)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: VerbEntity.self, WordEntity.self, TranslationEntity.self,
        configurations: config
    )
    
    return MainTabView()
        .modelContainer(container)
}
