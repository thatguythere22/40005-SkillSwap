//
//  SkillSwapApp.swift
//  SkillSwap
//
//  Created by Zade Elsaddik on 7/10/2026.
//

import SwiftUI
import CoreData

@main
struct SkillSwapApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
