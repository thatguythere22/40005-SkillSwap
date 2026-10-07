import SwiftUI

struct ActivityView: View {
    enum Segment: String, CaseIterable, Identifiable {
        case requests = "My Posts"
        case offers = "Offers"
        var id: String { rawValue }
    }

    @StateObject private var viewModel: ActivityViewModel
    @State private var segment: Segment = .requests
    let container: DependencyContainer

    init(viewModel: ActivityViewModel, container: DependencyContainer) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.container = container
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Activity", selection: $segment) {
                    ForEach(Segment.allCases) { item in
                        Text(item.rawValue).tag(item)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 18)
                .padding(.bottom, 12)

                ScrollView {
                    content
                        .padding(.horizontal, 18)
                        .padding(.bottom, 30)
                }
            }
            .background(SkillSwapTheme.canvas)
            .navigationTitle("Activity")
            .onAppear(perform: viewModel.refresh)
            .refreshable { viewModel.refresh() }
            .alert("Unable to Load Activity", isPresented: errorBinding) {
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if segment == .requests {
            if viewModel.requests.isEmpty {
                SkillSwapEmptyState(
                    title: "No posts yet",
                    message: "Your requests will appear here after you post a skill swap.",
                    systemImage: "square.and.pencil"
                )
            } else {
                LazyVStack(spacing: 14) {
                    ForEach(viewModel.requests) { request in
                        NavigationLink {
                            RequestDetailView(viewModel: container.makeRequestDetailViewModel(request: request))
                        } label: {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    StatusCapsule(status: request.status)
                                    Spacer()
                                    Text(DateDisplayFormatter.relativeString(for: request.createdAt))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Text(request.needTitle)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                HStack(spacing: 7) {
                                    Text("You offer")
                                        .foregroundStyle(.secondary)
                                    Text(request.offeredSkill)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(SkillSwapTheme.accent)
                                }
                                .font(.subheadline)
                            }
                            .padding(16)
                            .background(SkillSwapTheme.card)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        } else {
            if viewModel.offers.isEmpty {
                SkillSwapEmptyState(
                    title: "No offers yet",
                    message: "When someone offers to help with one of your requests, it will appear here.",
                    systemImage: "bubble.left.and.exclamationmark.bubble.right"
                )
            } else {
                LazyVStack(spacing: 14) {
                    ForEach(viewModel.offers) { offer in
                        OfferCard(offer: offer, onAccept: nil)
                    }
                }
            }
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(get: { viewModel.errorMessage != nil }, set: { if !$0 { viewModel.errorMessage = nil } })
    }
}
