import Foundation

enum BrowseOpenSkillRequestsError: LocalizedError, Equatable {
    case unableToLoad

    var errorDescription: String? {
        "SkillSwap could not load community requests. Please try again."
    }
}

/// Loads open requests that can still receive offers, excluding the current member's own posts.
struct BrowseOpenSkillRequestsUseCase {
    let repository: SkillSwapRepository

    func execute(currentMemberID: String, category: SkillCategory? = nil) throws -> [SkillRequest] {
        do {
            return try repository.fetchOpenRequests(excludingOwnerID: currentMemberID, category: category)
        } catch {
            throw BrowseOpenSkillRequestsError.unableToLoad
        }
    }
}
