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
        }
        .modelContainer(sharedModelContainer)
    }
}
