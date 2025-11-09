import SwiftUI

struct ListView: View {
    @StateObject private var viewModel: ListViewModel
    
    init(viewModel: ListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                Text("List")
                    .font(.largeTitle)
            }
        }
        .navigationTitle("List")
        .onAppear {
            viewModel.loadVerbs()
        }
    }
}

