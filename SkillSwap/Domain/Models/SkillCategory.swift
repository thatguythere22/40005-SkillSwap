import Foundation

/// A practical skill area used to organise requests on the SkillSwap community board.
enum SkillCategory: String, CaseIterable, Codable, Identifiable {
    case study = "Study"
    case technology = "Technology"
    case creative = "Creative"
    case language = "Language"
    case fitness = "Fitness"
    case practical = "Practical"
    case music = "Music"
    case other = "Other"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .study: "book.closed.fill"
        case .technology: "laptopcomputer"
        case .creative: "paintpalette.fill"
        case .language: "character.bubble.fill"
        case .fitness: "figure.run"
        case .practical: "wrench.and.screwdriver.fill"
        case .music: "music.note"
        case .other: "sparkles"
        }
    }
}
