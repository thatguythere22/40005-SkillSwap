import Foundation

enum GetOffersForRequestError: LocalizedError, Equatable {
    case unableToLoad

    var errorDescription: String? {
        "Offers for this request could not be loaded. Please try again."
    }
}

/// Loads the offers attached to one skill request.
struct GetOffersForRequestUseCase {
    let repository: SkillSwapRepository

    func execute(requestID: UUID) throws -> [SkillOffer] {
        do {
            return try repository.fetchOffers(requestID: requestID)
        } catch {
            throw GetOffersForRequestError.unableToLoad
        }
    }
}
