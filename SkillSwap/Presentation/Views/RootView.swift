import SwiftUI

struct RootView: View {
    let container: DependencyContainer

    var body: some View {
        TabView {
            HomeView(viewModel: container.makeHomeViewModel(), container: container)
                .tabItem { Label("Home", systemImage: "house.fill") }

            ExploreView(viewModel: container.makeExploreViewModel(), container: container)
                .tabItem { Label("Explore", systemImage: "safari.fill") }

            CreateRequestView(viewModel: container.makeCreateRequestViewModel())
                .tabItem { Label("Post", systemImage: "plus.circle.fill") }

            ActivityView(viewModel: container.makeActivityViewModel(), container: container)
                .tabItem { Label("Activity", systemImage: "bubble.left.and.bubble.right.fill") }

            ProfileView(profileStore: container.profileStore)
                .tabItem { Label("Me", systemImage: "person.crop.circle.fill") }
        }
        .tint(SkillSwapTheme.accent)
    }
}
