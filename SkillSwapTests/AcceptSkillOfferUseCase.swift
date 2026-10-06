import Foundation

enum AcceptSkillOfferError: LocalizedError, Equatable {
    case requestNotFound
    case notRequestOwner
    case requestUnavailable
    case offerNotFound
    case offerUnavailable
    case unableToAccept

    var errorDescription: String? {
        switch self {
        case .requestNotFound:
            "The original skill request could not be found."
        case .notRequestOwner:
            "Only the person who posted this request can accept an offer."
        case .requestUnavailable:
            "This request has already been matched or closed."
        case .offerNotFound:
            "This offer could not be found. Refresh your offers and try again."
        case .offerUnavailable:
            "This offer is no longer pending."
        case .unableToAccept:
            "SkillSwap could not accept this offer. Please try again."
        }
    }
}

/// Accepts one pending offer, marks the request as matched, and declines competing pending offers.
struct AcceptSkillOfferUseCase {
    let repository: SkillSwapRepository

    func execute(requestID: UUID, offerID: UUID, currentMemberID: String) throws {
        do {
            guard var request = try repository.fetchRequest(id: requestID) else {
                throw AcceptSkillOfferError.requestNotFound
            }
            guard request.ownerID == currentMemberID else { throw AcceptSkillOfferError.notRequestOwner }
            guard request.status == .open else { throw AcceptSkillOfferError.requestUnavailable }

            var offers = try repository.fetchOffers(requestID: requestID)
            guard let selectedIndex = offers.firstIndex(where: { $0.id == offerID }) else {
                throw AcceptSkillOfferError.offerNotFound
            }
            guard offers[selectedIndex].status == .pending else { throw AcceptSkillOfferError.offerUnavailable }

            request.status = .matched
            try repository.updateRequest(request)

            for index in offers.indices where offers[index].status == .pending {
                offers[index].status = offers[index].id == offerID ? .accepted : .declined
                try repository.updateOffer(offers[index])
            }
        } catch let error as AcceptSkillOfferError {
            throw error
        } catch {
            throw AcceptSkillOfferError.unableToAccept
        }
    }
}
