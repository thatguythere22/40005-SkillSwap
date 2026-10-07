import XCTest
@testable import SkillSwap

final class AcceptSkillOfferUseCaseTests: XCTestCase {
    func test_acceptOffer_matchesRequestAndDeclinesCompetingOffer() throws {
        let request = makeRequest(ownerID: "me")
        let chosen = SkillOffer(
            requestID: request.id,
            requestOwnerID: "me",
            offeredByID: "a",
            offeredByName: "Maya",
            skillProvided: "Bike repair",
            message: "I can help"
        )
        let competing = SkillOffer(
            requestID: request.id,
            requestOwnerID: "me",
            offeredByID: "b",
            offeredByName: "Noah",
            skillProvided: "Bike repair",
            message: "Also happy to help"
        )
        let repository = TestSkillSwapRepository(requests: [request], offers: [chosen, competing])
        let useCase = AcceptSkillOfferUseCase(repository: repository)

        try useCase.execute(requestID: request.id, offerID: chosen.id, currentMemberID: "me")

        XCTAssertEqual(repository.requests.first?.status, .matched)
        XCTAssertEqual(repository.offers.first(where: { $0.id == chosen.id })?.status, .accepted)
        XCTAssertEqual(repository.offers.first(where: { $0.id == competing.id })?.status, .declined)
    }

    func test_acceptOffer_rejectsNonOwner() {
        let request = makeRequest(ownerID: "owner")
        let offer = SkillOffer(
            requestID: request.id,
            requestOwnerID: "owner",
            offeredByID: "helper",
            offeredByName: "Maya",
            skillProvided: "Bike repair",
            message: "I can help"
        )
        let useCase = AcceptSkillOfferUseCase(repository: TestSkillSwapRepository(requests: [request], offers: [offer]))

        XCTAssertThrowsError(
            try useCase.execute(requestID: request.id, offerID: offer.id, currentMemberID: "someone-else")
        ) { error in
            XCTAssertEqual(error as? AcceptSkillOfferError, .notRequestOwner)
        }
    }
}
