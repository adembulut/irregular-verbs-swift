import SwiftUI

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
        let viewModel = ListViewModel(getAllVerbsUseCase: getAllVerbsUseCase)
        return ListView(viewModel: viewModel)
    }
}
