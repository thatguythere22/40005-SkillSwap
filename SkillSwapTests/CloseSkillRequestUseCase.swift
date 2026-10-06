import Foundation

enum CloseSkillRequestError: LocalizedError, Equatable {
    case requestNotFound
    case notRequestOwner
    case alreadyClosed
    case unableToClose

    var errorDescription: String? {
        switch self {
        case .requestNotFound:
            "This skill request could not be found."
        case .notRequestOwner:
            "Only the person who posted this request can close it."
        case .alreadyClosed:
            "This request is already closed."
        case .unableToClose:
            "SkillSwap could not close this request. Please try again."
        }
    }
}

/// Closes a request so it no longer appears on the open community board.
struct CloseSkillRequestUseCase {
    let repository: SkillSwapRepository

    func execute(requestID: UUID, currentMemberID: String) throws {
        do {
            guard var request = try repository.fetchRequest(id: requestID) else {
                throw CloseSkillRequestError.requestNotFound
            }
            guard request.ownerID == currentMemberID else { throw CloseSkillRequestError.notRequestOwner }
            guard request.status != .closed else { throw CloseSkillRequestError.alreadyClosed }
            request.status = .closed
            try repository.updateRequest(request)
        } catch let error as CloseSkillRequestError {
            throw error
        } catch {
            throw CloseSkillRequestError.unableToClose
        }
    }
}
