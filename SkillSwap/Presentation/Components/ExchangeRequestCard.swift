import SwiftUI

struct ExchangeRequestCard: View {
    let request: SkillRequest

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 10) {
                Circle()
                    .fill(SkillSwapTheme.accent.opacity(0.16))
                    .frame(width: 38, height: 38)
                    .overlay(
                        Text(String(request.ownerName.prefix(1)).uppercased())
                            .font(.headline.weight(.bold))
                            .foregroundStyle(SkillSwapTheme.accent)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(request.ownerName)
                        .font(.subheadline.weight(.semibold))
                    Text(DateDisplayFormatter.relativeString(for: request.createdAt))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()
                Image(systemName: request.category.systemImage)
                    .foregroundStyle(SkillSwapTheme.accent)
                    .padding(9)
                    .background(SkillSwapTheme.accent.opacity(0.10))
                    .clipShape(Circle())
            }

            Text(request.needTitle)
                .font(.title3.weight(.bold))
                .foregroundStyle(.primary)
                .lineLimit(2)

            HStack(spacing: 9) {
                Label(request.needTitle, systemImage: "hand.raised.fill")
                    .lineLimit(1)
                Image(systemName: "arrow.left.arrow.right")
                    .foregroundStyle(SkillSwapTheme.warm)
                Label(request.offeredSkill, systemImage: "hand.thumbsup.fill")
                    .lineLimit(1)
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)

            HStack {
                Label(request.availability.isEmpty ? "Flexible timing" : request.availability, systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Spacer()
                Text(request.category.rawValue)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(SkillSwapTheme.accent)
            }
        }
        .padding(17)
        .background(SkillSwapTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.primary.opacity(0.05), lineWidth: 1)
        )
    }
}
