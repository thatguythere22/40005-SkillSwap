//
//  SkillSwapApp.swift
//  SkillSwap
//
//  Created by Zade Elsaddik on 7/10/2026.
//

import SwiftUI

@main
@MainActor
struct SkillSwapApp: App {
    private let container: DependencyContainer

    init() {
        container = DependencyContainer()
    }

    var body: some Scene {
        WindowGroup {
            RootView(container: container)
        }
    }
}
