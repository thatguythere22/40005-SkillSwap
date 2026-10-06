import Foundation

/// The current state of a skill exchange request.
enum SkillRequestStatus: String, Codable, CaseIterable {
    case open
    case matched
    case closed

    var displayName: String {
        switch self {
        case .open: "Open"
        case .matched: "Matched"
        case .closed: "Closed"
        }
    }
}
