import SwiftUI

struct RequestDetailView: View {
    @StateObject private var viewModel: RequestDetailViewModel

    init(viewModel: RequestDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                exchangeHero
                descriptionCard

                if viewModel.isOwner {
                    ownerSection
                } else if viewModel.request.status == .open {
                    offerSection
                }
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 34)
        }
        .background(SkillSwapTheme.canvas)
        .navigationTitle("Skill Request")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: viewModel.refreshOffers)
        .alert("SkillSwap", isPresented: errorBinding) {
            Button("OK", role: .cancel) { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .alert("Updated", isPresented: confirmationBinding) {
            Button("Done", role: .cancel) { viewModel.confirmationMessage = nil }
        } message: {
            Text(viewModel.confirmationMessage ?? "")
        }
    }

    private var exchangeHero: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(viewModel.request.ownerName)
                        .font(.headline)
                    Text(viewModel.request.category.rawValue)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.75))
                }
                Spacer()
                StatusCapsule(status: viewModel.request.status)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("NEEDS")
                    .font(.caption2.bold())
                    .tracking(1.2)
                    .foregroundStyle(.white.opacity(0.7))
                Text(viewModel.request.needTitle)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
            }

            HStack(spacing: 10) {
                Rectangle().fill(.white.opacity(0.25)).frame(height: 1)
                Image(systemName: "arrow.left.arrow.right")
                    .foregroundStyle(.white)
                Rectangle().fill(.white.opacity(0.25)).frame(height: 1)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("OFFERS IN RETURN")
                    .font(.caption2.bold())
                    .tracking(1.2)
                    .foregroundStyle(.white.opacity(0.7))
                Text(viewModel.request.offeredSkill)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
            }
        }
        .padding(22)
        .background(SkillSwapTheme.heroGradient)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private var descriptionCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("What they need")
                .font(.headline)
            Text(viewModel.request.needDescription)
                .font(.body)
                .foregroundStyle(.secondary)
            Divider()
            Label(
                viewModel.request.availability.isEmpty ? "Flexible timing" : viewModel.request.availability,
                systemImage: "clock.fill"
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding(18)
        .background(SkillSwapTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    @ViewBuilder
    private var ownerSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Offers")
                    .font(.title3.bold())
                Spacer()
                Text("\(viewModel.offers.filter { $0.status == .pending }.count) pending")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            if viewModel.offers.isEmpty {
                SkillSwapEmptyState(
                    title: "No offers yet",
                    message: "Other community members can respond while this request remains open.",
                    systemImage: "bubble.left"
                )
                .frame(maxWidth: .infinity)
                .background(SkillSwapTheme.card)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            } else {
                ForEach(viewModel.offers) { offer in
                    VStack(spacing: 10) {
                        OfferCard(
                            offer: offer,
                            onAccept: viewModel.request.status == .open && offer.status == .pending ? {
                                viewModel.accept(offer)
                            } : nil
                        )
                        if offer.status == .accepted {
                            Button {
                                Task { await viewModel.scheduleReminder(for: offer) }
                            } label: {
                                Label("Test session reminder", systemImage: "bell.badge.fill")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .tint(SkillSwapTheme.purple)
                        }
                    }
                }
            }

            if viewModel.request.status != .closed {
                Button(role: .destructive, action: viewModel.closeRequest) {
                    Label("Close this request", systemImage: "xmark.circle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private var offerSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Propose a swap")
                .font(.title3.bold())
            Text("Tell \(viewModel.request.ownerName) exactly how you can help and what you would like to exchange.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TextField("Skill you can provide", text: $viewModel.offerSkill)
                .padding(13)
                .background(Color(uiColor: .tertiarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            TextField("Short message", text: $viewModel.offerMessage, axis: .vertical)
                .lineLimit(3...6)
                .padding(13)
                .background(Color(uiColor: .tertiarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            Button(action: viewModel.submitOffer) {
                Label("Send offer", systemImage: "paperplane.fill")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(SkillSwapTheme.accent)
        }
        .padding(18)
        .background(SkillSwapTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private var errorBinding: Binding<Bool> {
        Binding(get: { viewModel.errorMessage != nil }, set: { if !$0 { viewModel.errorMessage = nil } })
    }

    private var confirmationBinding: Binding<Bool> {
        Binding(get: { viewModel.confirmationMessage != nil }, set: { if !$0 { viewModel.confirmationMessage = nil } })
    }
}
