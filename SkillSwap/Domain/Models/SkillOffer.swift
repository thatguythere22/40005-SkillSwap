import Foundation

/// An offer from another community member to help with a posted skill request.
///
/// An offer identifies the request being answered, the skill the helper can provide,
/// and the message that explains the proposed exchange.
struct SkillOffer: Identifiable, Codable, Equatable {
    let id: UUID
    let requestID: UUID
    let requestOwnerID: String
    let offeredByID: String
    var offeredByName: String
    var skillProvided: String
    var message: String
    let createdAt: Date
    var status: SkillOfferStatus

    init(
        id: UUID = UUID(),
        requestID: UUID,
        requestOwnerID: String,
        offeredByID: String,
        offeredByName: String,
        skillProvided: String,
        message: String,
        createdAt: Date = Date(),
        status: SkillOfferStatus = .pending
    ) {
        self.id = id
        self.requestID = requestID
        self.requestOwnerID = requestOwnerID
        self.offeredByID = offeredByID
        self.offeredByName = offeredByName
        self.skillProvided = skillProvided
        self.message = message
        self.createdAt = createdAt
        self.status = status
    }
}
