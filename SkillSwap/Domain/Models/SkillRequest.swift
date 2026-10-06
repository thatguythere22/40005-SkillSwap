import Foundation

/// A request posted by one community member describing both sides of a proposed skill exchange.
///
/// Business rules:
/// - A request must describe a skill the member needs and a different skill they can offer.
/// - Only open requests can receive new offers.
/// - Once an offer is accepted the request becomes matched.
struct SkillRequest: Identifiable, Codable, Equatable {
    let id: UUID
    let ownerID: String
    var ownerName: String
    var needTitle: String
    var needDescription: String
    var offeredSkill: String
    var category: SkillCategory
    var availability: String
    let createdAt: Date
    var status: SkillRequestStatus

    init(
        id: UUID = UUID(),
        ownerID: String,
        ownerName: String,
        needTitle: String,
        needDescription: String,
        offeredSkill: String,
        category: SkillCategory,
        availability: String,
        createdAt: Date = Date(),
        status: SkillRequestStatus = .open
    ) {
        self.id = id
        self.ownerID = ownerID
        self.ownerName = ownerName
        self.needTitle = needTitle
        self.needDescription = needDescription
        self.offeredSkill = offeredSkill
        self.category = category
        self.availability = availability
        self.createdAt = createdAt
        self.status = status
    }
}
