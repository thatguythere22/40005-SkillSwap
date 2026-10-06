import Foundation

enum GetIncomingOffersError: LocalizedError, Equatable {
    case unableToLoad

    var errorDescription: String? {
        "SkillSwap could not load the offers on your requests. Please try again."
    }
}

/// Loads offers made to requests owned by the current member.
struct GetIncomingOffersUseCase {
    let repository: SkillSwapRepository

    func execute(memberID: String) throws -> [SkillOffer] {
        do {
            return try repository.fetchIncomingOffers(requestOwnerID: memberID)
        } catch {
            throw GetIncomingOffersError.unableToLoad
        }
    }
}
