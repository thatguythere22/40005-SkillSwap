import SwiftUI

struct CreateRequestView: View {
    @StateObject private var viewModel: CreateRequestViewModel

    init(viewModel: CreateRequestViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    introCard
                    exchangeFields
                    detailsFields
                    postButton
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 34)
            }
            .background(SkillSwapTheme.canvas)
            .navigationTitle("Post a Swap")
            .navigationBarTitleDisplayMode(.large)
            .alert("Check Your Request", isPresented: errorBinding) {
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .alert("Request Posted", isPresented: successBinding) {
                Button("Done", role: .cancel) { viewModel.successMessage = nil }
            } message: {
                Text(viewModel.successMessage ?? "")
            }
        }
    }

    private var introCard: some View {
        HStack(spacing: 14) {
            Image(systemName: "arrow.left.arrow.right.circle.fill")
                .font(.system(size: 38))
                .foregroundStyle(SkillSwapTheme.warm)
            VStack(alignment: .leading, spacing: 4) {
                Text("Make the exchange clear")
                    .font(.headline)
                Text("Say what you need, what you can offer, and enough detail for someone to decide if they can help.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(17)
        .background(SkillSwapTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private var exchangeFields: some View {
        VStack(spacing: 12) {
            fieldCard(
                title: "I need help with",
                icon: "hand.raised.fill",
                tint: SkillSwapTheme.warm
            ) {
                TextField("e.g. Fixing a bike chain", text: $viewModel.needTitle)
                    .textInputAutocapitalization(.sentences)
            }

            HStack {
                Rectangle().fill(Color.secondary.opacity(0.2)).frame(height: 1)
                Image(systemName: "arrow.up.arrow.down")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                Rectangle().fill(Color.secondary.opacity(0.2)).frame(height: 1)
            }
            .padding(.horizontal, 30)

            fieldCard(
                title: "I can offer",
                icon: "hand.thumbsup.fill",
                tint: SkillSwapTheme.accent
            ) {
                TextField("e.g. Photoshop help", text: $viewModel.offeredSkill)
                    .textInputAutocapitalization(.sentences)
            }
        }
    }

    private var detailsFields: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Details")
                .font(.title3.bold())

            VStack(alignment: .leading, spacing: 8) {
                Text("Explain what you need")
                    .font(.subheadline.weight(.semibold))
                TextEditor(text: $viewModel.needDescription)
                    .frame(minHeight: 110)
                    .padding(10)
                    .scrollContentBackground(.hidden)
                    .background(Color(uiColor: .tertiarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Category")
                    .font(.subheadline.weight(.semibold))
                Picker("Category", selection: $viewModel.category) {
                    ForEach(SkillCategory.allCases) { category in
                        Label(category.rawValue, systemImage: category.systemImage).tag(category)
                    }
                }
                .pickerStyle(.menu)
                .tint(SkillSwapTheme.accent)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("When are you usually free?")
                    .font(.subheadline.weight(.semibold))
                TextField("e.g. Weeknights after 6 pm", text: $viewModel.availability)
                    .padding(13)
                    .background(Color(uiColor: .tertiarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .padding(18)
        .background(SkillSwapTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private var postButton: some View {
        Button(action: viewModel.post) {
            HStack {
                Image(systemName: "paperplane.fill")
                Text("Post skill request")
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
        }
        .buttonStyle(.borderedProminent)
        .tint(SkillSwapTheme.accent)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func fieldCard<Content: View>(
        title: String,
        icon: String,
        tint: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        HStack(spacing: 13) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(tint)
                .frame(width: 42, height: 42)
                .background(tint.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                content()
                    .font(.headline)
            }
        }
        .padding(16)
        .background(SkillSwapTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var errorBinding: Binding<Bool> {
        Binding(get: { viewModel.errorMessage != nil }, set: { if !$0 { viewModel.errorMessage = nil } })
    }

    private var successBinding: Binding<Bool> {
        Binding(get: { viewModel.successMessage != nil }, set: { if !$0 { viewModel.successMessage = nil } })
    }
}
