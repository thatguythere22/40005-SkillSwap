import XCTest
@testable import SkillSwap

final class SubmitSkillOfferUseCaseTests: XCTestCase {
    func test_submitOffer_savesOfferOnOpenRequest() throws {
        let request = makeRequest(ownerID: "owner")
        let repository = TestSkillSwapRepository(requests: [request])
        let useCase = SubmitSkillOfferUseCase(repository: repository)

        let offer = try useCase.execute(
            requestID: request.id,
            memberID: "helper",
            memberName: "Maya",
            skillProvided: "Bike repair",
            message: "I can show you how to adjust the derailleur."
        )

        XCTAssertEqual(offer.status, .pending)
        XCTAssertEqual(repository.offers.count, 1)
    }

    func test_submitOffer_rejectsOfferOnOwnRequest() {
        let request = makeRequest(ownerID: "me")
        let useCase = SubmitSkillOfferUseCase(repository: TestSkillSwapRepository(requests: [request]))

        XCTAssertThrowsError(
            try useCase.execute(
                requestID: request.id,
                memberID: "me",
                memberName: "Zade",
                skillProvided: "Bike repair",
                message: "I can help."
            )
        ) { error in
            XCTAssertEqual(error as? SubmitSkillOfferError, .ownRequest)
        }
    }

    func test_submitOffer_rejectsDuplicateOfferFromSameMember() throws {
        let request = makeRequest(ownerID: "owner")
        let existing = SkillOffer(
            requestID: request.id,
            requestOwnerID: request.ownerID,
            offeredByID: "helper",
            offeredByName: "Maya",
            skillProvided: "Bike repair",
            message: "First offer"
        )
        let repository = TestSkillSwapRepository(requests: [request], offers: [existing])
        let useCase = SubmitSkillOfferUseCase(repository: repository)

        XCTAssertThrowsError(
            try useCase.execute(
                requestID: request.id,
                memberID: "helper",
                memberName: "Maya",
                skillProvided: "Bike repair",
                message: "Second offer"
            )
        ) { error in
            XCTAssertEqual(error as? SubmitSkillOfferError, .duplicateOffer)
        }
    }
}
