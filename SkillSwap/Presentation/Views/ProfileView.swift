import SwiftUI

struct ProfileView: View {
    @ObservedObject var profileStore: ProfileStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    profileHeader
                    editCard
                    principlesCard
                    extensionTip
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 32)
            }
            .background(SkillSwapTheme.canvas)
            .navigationTitle("Profile")
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(SkillSwapTheme.heroGradient)
                .frame(width: 92, height: 92)
                .overlay(
                    Text(String(profileStore.displayName.prefix(1)).uppercased())
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.white)
                )
            Text(profileStore.displayName)
                .font(.title2.bold())
            Text(profileStore.headline)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 22)
    }

    private var editCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your swap profile")
                .font(.headline)

            VStack(alignment: .leading, spacing: 6) {
                Text("Display name").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                TextField("Display name", text: $profileStore.displayName)
                    .textContentType(.name)
            }

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                Text("Short intro").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                TextField("Tell people how you like to help", text: $profileStore.headline, axis: .vertical)
                    .lineLimit(2...4)
            }

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                Text("Skills you can offer").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                TextField("e.g. Excel, guitar, photography", text: $profileStore.skills)
            }
        }
        .padding(18)
        .background(SkillSwapTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private var principlesCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Good swaps are simple")
                .font(.headline)
            Label("Agree on what each person will help with before meeting.", systemImage: "checkmark.seal.fill")
            Label("Keep personal contact details out of public posts.", systemImage: "lock.fill")
            Label("Close a request once you have found the right exchange.", systemImage: "flag.checkered")
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .padding(18)
        .background(SkillSwapTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private var extensionTip: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "text.badge.plus")
                .foregroundStyle(SkillSwapTheme.purple)
                .font(.title2)
            VStack(alignment: .leading, spacing: 4) {
                Text("SkillSwap Draft action")
                    .font(.headline)
                Text("Select rough request text in a supported app and use the SkillSwap action to turn it into a consistent exchange format.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .background(SkillSwapTheme.purple.opacity(0.09))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}
