import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel: ExploreViewModel
    let container: DependencyContainer

    init(viewModel: ExploreViewModel, container: DependencyContainer) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.container = container
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    searchField
                    filters

                    if viewModel.visibleRequests.isEmpty {
                        SkillSwapEmptyState(
                            title: "No matching swaps",
                            message: "Try a different search or category. Open requests will appear here.",
                            systemImage: "magnifyingglass"
                        )
                        .padding(.top, 28)
                    } else {
                        LazyVStack(spacing: 14) {
                            ForEach(viewModel.visibleRequests) { request in
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
                .padding(.horizontal, 18)
                .padding(.bottom, 30)
            }
            .background(SkillSwapTheme.canvas)
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .onAppear(perform: viewModel.refresh)
            .onChange(of: viewModel.selectedCategory) { _, _ in viewModel.refresh() }
            .refreshable { viewModel.refresh() }
            .alert("Unable to Load Requests", isPresented: errorBinding) {
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Search skills, help or offers", text: $viewModel.searchText)
                .textInputAutocapitalization(.never)
            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 48)
        .background(SkillSwapTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var filters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 9) {
                Button {
                    viewModel.selectedCategory = nil
                } label: {
                    Text("All")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 9)
                        .foregroundStyle(viewModel.selectedCategory == nil ? .white : .primary)
                        .background(viewModel.selectedCategory == nil ? SkillSwapTheme.accent : Color(uiColor: .tertiarySystemGroupedBackground))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)

                ForEach(SkillCategory.allCases) { category in
                    Button {
                        viewModel.selectedCategory = category
                    } label: {
                        CategoryPill(category: category, selected: viewModel.selectedCategory == category)
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
