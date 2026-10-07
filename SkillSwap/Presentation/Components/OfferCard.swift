import SwiftUI

struct OfferCard: View {
    let offer: SkillOffer
    let onAccept: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(SkillSwapTheme.purple.opacity(0.14))
                    .frame(width: 38, height: 38)
                    .overlay(
                        Text(String(offer.offeredByName.prefix(1)).uppercased())
                            .font(.headline.weight(.bold))
                            .foregroundStyle(SkillSwapTheme.purple)
                    )
                VStack(alignment: .leading, spacing: 2) {
                    Text(offer.offeredByName)
                        .font(.headline)
                    Text(offer.skillProvided)
                        .font(.subheadline)
                        .foregroundStyle(SkillSwapTheme.purple)
                }
                Spacer()
                Text(offer.status.displayName)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
            }

            Text(offer.message)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if offer.status == .pending, let onAccept {
                Button(action: onAccept) {
                    Text("Accept exchange")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(SkillSwapTheme.accent)
            }
        }
        .padding(16)
        .background(SkillSwapTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
