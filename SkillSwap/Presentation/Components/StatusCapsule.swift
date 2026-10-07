import SwiftUI

struct StatusCapsule: View {
    let status: SkillRequestStatus

    var body: some View {
        Text(status.displayName.uppercased())
            .font(.caption2.weight(.bold))
            .tracking(0.7)
            .foregroundStyle(foreground)
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(background)
            .clipShape(Capsule())
    }

    private var foreground: Color {
        switch status {
        case .open: SkillSwapTheme.accent
        case .matched: SkillSwapTheme.purple
        case .closed: .secondary
        }
    }

    private var background: Color {
        foreground.opacity(0.14)
    }
}
