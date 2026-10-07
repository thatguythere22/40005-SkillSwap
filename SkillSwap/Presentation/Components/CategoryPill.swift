import SwiftUI

struct CategoryPill: View {
    let category: SkillCategory
    let selected: Bool

    var body: some View {
        HStack(spacing: 7) {
            Image(systemName: category.systemImage)
            Text(category.rawValue)
                .fontWeight(.semibold)
        }
        .font(.subheadline)
        .padding(.horizontal, 13)
        .padding(.vertical, 9)
        .foregroundStyle(selected ? .white : .primary)
        .background(selected ? SkillSwapTheme.accent : Color(uiColor: .tertiarySystemGroupedBackground))
        .clipShape(Capsule())
    }
}
