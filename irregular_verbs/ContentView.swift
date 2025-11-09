//
//  ContentView.swift
//  irregular_verbs
//
//  Created by adem bulut on 9.11.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if isLoading {
                SplashView()
            } else {
                MainTabView()
            }
        }
        .task {
            await loadInitialData()
        }
    }
    
    private func loadInitialData() async {
        let startTime = Date()
        
        // Skip in test environment
        guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil else {
            isLoading = false
            return
        }
        
        // Check if repository is empty
        let repository = VerbRepository(modelContext: modelContext)
        let isEmpty = repository.isEmpty()
        
        if isEmpty {
            // Load from JSON
            let loadVerbsUseCase = LoadVerbsFromJSONUseCase(repository: repository)
            do {
                try await loadVerbsUseCase.execute()
            } catch {
                #if DEBUG
                print("Error loading verbs from JSON: \(error)")
                #endif
            }
        }
        
        // Ensure minimum splash time of 1 second if no loading was needed
        let elapsed = Date().timeIntervalSince(startTime)
        let minimumTime: TimeInterval = isEmpty ? 0 : 1.0
        
        if elapsed < minimumTime {
            try? await Task.sleep(nanoseconds: UInt64((minimumTime - elapsed) * 1_000_000_000))
        }
        
        isLoading = false
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [VerbEntity.self, WordEntity.self, TranslationEntity.self])
}
