import SwiftUI

enum SkillSwapTheme {
    static let canvas = Color(uiColor: .systemGroupedBackground)
    static let card = Color(uiColor: .secondarySystemGroupedBackground)
    static let accent = Color(red: 0.20, green: 0.48, blue: 0.46)
    static let warm = Color(red: 0.90, green: 0.45, blue: 0.30)
    static let purple = Color(red: 0.47, green: 0.38, blue: 0.75)

    static let heroGradient = LinearGradient(
        colors: [accent, Color(red: 0.12, green: 0.31, blue: 0.35)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
