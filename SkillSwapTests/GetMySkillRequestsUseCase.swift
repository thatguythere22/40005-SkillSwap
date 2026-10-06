import Foundation

enum GetMySkillRequestsError: LocalizedError, Equatable {
    case unableToLoad

    var errorDescription: String? {
        "Your skill requests could not be loaded. Please try again."
    }
}

/// Loads requests posted by the current SkillSwap member.
struct GetMySkillRequestsUseCase {
    let repository: SkillSwapRepository

    func execute(memberID: String) throws -> [SkillRequest] {
        do {
            return try repository.fetchRequests(ownerID: memberID)
        } catch {
            throw GetMySkillRequestsError.unableToLoad
        }
    }
}
