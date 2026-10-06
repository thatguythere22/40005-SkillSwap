import Foundation

/// The outcome state of an offer made against a skill request.
enum SkillOfferStatus: String, Codable {
    case pending
    case accepted
    case declined

    var displayName: String {
        switch self {
        case .pending: "Pending"
        case .accepted: "Accepted"
        case .declined: "Declined"
        }
    }
}
