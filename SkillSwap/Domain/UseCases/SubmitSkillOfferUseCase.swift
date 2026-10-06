import Foundation

enum SubmitSkillOfferError: LocalizedError, Equatable {
    case requestNotFound
    case ownRequest
    case requestClosed
    case missingSkill
    case missingMessage
    case duplicateOffer
    case unableToSave

    var errorDescription: String? {
        switch self {
        case .requestNotFound:
            "This skill request is no longer available. Refresh the board and try again."
        case .ownRequest:
            "You cannot make an offer on your own skill request."
        case .requestClosed:
            "This request is already matched or closed and cannot receive new offers."
        case .missingSkill:
            "Tell the requester which skill you can provide."
        case .missingMessage:
            "Add a short message explaining how you can help."
        case .duplicateOffer:
            "You have already made an offer on this request."
        case .unableToSave:
            "SkillSwap could not send your offer. Please try again."
        }
    }
}

/// Creates an offer on an open request while preventing self-offers and duplicate offers.
struct SubmitSkillOfferUseCase {
    let repository: SkillSwapRepository

    func execute(
        requestID: UUID,
        memberID: String,
        memberName: String,
        skillProvided: String,
        message: String
    ) throws -> SkillOffer {
        let request: SkillRequest
        do {
            guard let found = try repository.fetchRequest(id: requestID) else {
                throw SubmitSkillOfferError.requestNotFound
            }
            request = found
        } catch let error as SubmitSkillOfferError {
            throw error
        } catch {
            throw SubmitSkillOfferError.unableToSave
        }

        guard request.ownerID != memberID else { throw SubmitSkillOfferError.ownRequest }
        guard request.status == .open else { throw SubmitSkillOfferError.requestClosed }

        let skill = skillProvided.trimmingCharacters(in: .whitespacesAndNewlines)
        let note = message.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !skill.isEmpty else { throw SubmitSkillOfferError.missingSkill }
        guard !note.isEmpty else { throw SubmitSkillOfferError.missingMessage }

        do {
            let existing = try repository.fetchOffers(requestID: requestID)
            guard !existing.contains(where: { $0.offeredByID == memberID }) else {
                throw SubmitSkillOfferError.duplicateOffer
            }

            let offer = SkillOffer(
                requestID: request.id,
                requestOwnerID: request.ownerID,
                offeredByID: memberID,
                offeredByName: memberName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Community member" : memberName,
                skillProvided: skill,
                message: note
            )
            try repository.saveOffer(offer)
            return offer
        } catch let error as SubmitSkillOfferError {
            throw error
        } catch {
            throw SubmitSkillOfferError.unableToSave
        }
    }
}
