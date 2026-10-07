import Foundation
@testable import SkillSwap

final class TestSkillSwapRepository: SkillSwapRepository {
    var requests: [SkillRequest]
    var offers: [SkillOffer]
    var shouldFail = false

    init(requests: [SkillRequest] = [], offers: [SkillOffer] = []) {
        self.requests = requests
        self.offers = offers
    }

    func fetchOpenRequests(excludingOwnerID: String, category: SkillCategory?) throws -> [SkillRequest] {
        if shouldFail { throw TestRepositoryError.forcedFailure }
        return requests
            .filter { $0.status == .open && $0.ownerID != excludingOwnerID }
            .filter { category == nil || $0.category == category }
            .sorted { $0.createdAt > $1.createdAt }
    }

    func fetchRequests(ownerID: String) throws -> [SkillRequest] {
        if shouldFail { throw TestRepositoryError.forcedFailure }
        return requests.filter { $0.ownerID == ownerID }
    }

    func fetchRequest(id: UUID) throws -> SkillRequest? {
        if shouldFail { throw TestRepositoryError.forcedFailure }
        return requests.first { $0.id == id }
    }

    func saveRequest(_ request: SkillRequest) throws {
        if shouldFail { throw TestRepositoryError.forcedFailure }
        requests.append(request)
    }

    func updateRequest(_ request: SkillRequest) throws {
        if shouldFail { throw TestRepositoryError.forcedFailure }
        guard let index = requests.firstIndex(where: { $0.id == request.id }) else { return }
        requests[index] = request
    }

    func fetchOffers(requestID: UUID) throws -> [SkillOffer] {
        if shouldFail { throw TestRepositoryError.forcedFailure }
        return offers.filter { $0.requestID == requestID }
    }

    func fetchIncomingOffers(requestOwnerID: String) throws -> [SkillOffer] {
        if shouldFail { throw TestRepositoryError.forcedFailure }
        return offers.filter { $0.requestOwnerID == requestOwnerID }
    }

    func saveOffer(_ offer: SkillOffer) throws {
        if shouldFail { throw TestRepositoryError.forcedFailure }
        offers.append(offer)
    }

    func updateOffer(_ offer: SkillOffer) throws {
        if shouldFail { throw TestRepositoryError.forcedFailure }
        guard let index = offers.firstIndex(where: { $0.id == offer.id }) else { return }
        offers[index] = offer
    }
}

enum TestRepositoryError: Error {
    case forcedFailure
}

func makeRequest(
    id: UUID = UUID(),
    ownerID: String = "owner-1",
    need: String = "Bike repair",
    offer: String = "Photoshop help",
    category: SkillCategory = .practical,
    status: SkillRequestStatus = .open
) -> SkillRequest {
    SkillRequest(
        id: id,
        ownerID: ownerID,
        ownerName: "Alex",
        needTitle: need,
        needDescription: "Need a bit of practical help.",
        offeredSkill: offer,
        category: category,
        availability: "Afternoons",
        status: status
    )
}
