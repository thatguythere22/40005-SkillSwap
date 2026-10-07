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
