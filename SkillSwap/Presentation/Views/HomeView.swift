import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @ObservedObject private var profileStore: ProfileStore
    let container: DependencyContainer

    init(viewModel: HomeViewModel, container: DependencyContainer) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _profileStore = ObservedObject(wrappedValue: container.profileStore)
        self.container = container
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    hero
                    categoryStrip
                    spotlight
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 32)
            }
            .background(SkillSwapTheme.canvas)
            .navigationBarHidden(true)
            .onAppear(perform: viewModel.refresh)
            .refreshable { viewModel.refresh() }
            .alert("Unable to Refresh", isPresented: errorBinding) {
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                Text("SkillSwap")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(SkillSwapTheme.accent)
                    .textCase(.uppercase)
                    .tracking(1.2)
                Text("Hey, \(profileStore.displayName)")
                    .font(.largeTitle.bold())
            }
            Spacer()
            Circle()
                .fill(SkillSwapTheme.accent.opacity(0.15))
                .frame(width: 48, height: 48)
                .overlay(
                    Text(String(profileStore.displayName.prefix(1)).uppercased())
                        .font(.title3.bold())
                        .foregroundStyle(SkillSwapTheme.accent)
                )
        }
        .padding(.top, 12)
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.title2.weight(.semibold))
                Spacer()
                Text("SKILLS, NOT MONEY")
                    .font(.caption2.weight(.bold))
                    .tracking(1)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.white.opacity(0.14))
                    .clipShape(Capsule())
            }

            Text("Trade what you know\nfor what you need.")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Post one thing you need help with and one skill you can offer in return.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.82))

            HStack(spacing: 8) {
                Label("No payments", systemImage: "dollarsign.slash")
                Label("Peer to peer", systemImage: "person.2.fill")
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(.white.opacity(0.9))
        }
        .padding(22)
        .background(SkillSwapTheme.heroGradient)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private var categoryStrip: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Browse by skill")
                .font(.title3.bold())
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(SkillCategory.allCases.prefix(6)) { category in
                        VStack(spacing: 8) {
                            Image(systemName: category.systemImage)
                                .font(.title3)
                                .foregroundStyle(SkillSwapTheme.accent)
                            Text(category.rawValue)
                                .font(.caption.weight(.semibold))
                        }
                        .frame(width: 78, height: 72)
                        .background(SkillSwapTheme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                }
            }
        }
    }

    private var spotlight: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Community requests")
                    .font(.title3.bold())
                Spacer()
                Text("Open now")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            if viewModel.requests.isEmpty {
                SkillSwapEmptyState(
                    title: "Nothing open yet",
                    message: "New skill requests will appear here when community members post them.",
                    systemImage: "person.2.wave.2"
                )
                .frame(maxWidth: .infinity)
                .background(SkillSwapTheme.card)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            } else {
                ForEach(viewModel.requests) { request in
                    NavigationLink {
                        RequestDetailView(viewModel: container.makeRequestDetailViewModel(request: request))
                    } label: {
                        ExchangeRequestCard(request: request)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }
}
