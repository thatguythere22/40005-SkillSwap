import Foundation

/// Persistence boundary for SkillSwap's skill requests and exchange offers.
protocol SkillSwapRepository {
    func fetchOpenRequests(excludingOwnerID: String, category: SkillCategory?) throws -> [SkillRequest]
    func fetchRequests(ownerID: String) throws -> [SkillRequest]
    func fetchRequest(id: UUID) throws -> SkillRequest?
    func saveRequest(_ request: SkillRequest) throws
    func updateRequest(_ request: SkillRequest) throws

    func fetchOffers(requestID: UUID) throws -> [SkillOffer]
    func fetchIncomingOffers(requestOwnerID: String) throws -> [SkillOffer]
    func saveOffer(_ offer: SkillOffer) throws
    func updateOffer(_ offer: SkillOffer) throws
}
