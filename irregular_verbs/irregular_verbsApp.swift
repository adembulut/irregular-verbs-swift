//
//  irregular_verbsApp.swift
//  irregular_verbs
//
//  Created by adem bulut on 9.11.2025.
//

import SwiftUI
import SwiftData

@main
struct irregular_verbsApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            VerbEntity.self,
            WordEntity.self,
            TranslationEntity.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    // Load verbs from JSON if needed using UseCase
                    // Skip in test environment
                    guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil else {
                        return // Running in test environment
                    }
                    
                    let modelContext = sharedModelContainer.mainContext
                    let repository = VerbRepository(modelContext: modelContext)
                    let loadVerbsUseCase = LoadVerbsFromJSONUseCase(repository: repository)
                    
                    do {
                        try await loadVerbsUseCase.execute()
                    } catch {
                        // Only print in debug mode
                        #if DEBUG
                        print("Error loading verbs from JSON: \(error)")
                        #endif
                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
