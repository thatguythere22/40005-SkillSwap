import XCTest
@testable import SkillSwap

final class TestSkillSwapRepositoryTests: XCTestCase {
    func test_fetchOpenRequests_returnsOnlyOpenRequestsFromOtherMembers() throws {
        let own = makeRequest(ownerID: "me")
        let openCommunity = makeRequest(ownerID: "other")
        let closedCommunity = makeRequest(ownerID: "other-2", status: .closed)
        let repository = TestSkillSwapRepository(requests: [own, openCommunity, closedCommunity])

        let results = try repository.fetchOpenRequests(excludingOwnerID: "me", category: nil)

        XCTAssertEqual(results.map(\.id), [openCommunity.id])
    }

    func test_fetchOffers_returnsOnlyOffersAttachedToSelectedRequest() throws {
        let firstRequestID = UUID()
        let secondRequestID = UUID()
        let firstOffer = SkillOffer(
            requestID: firstRequestID,
            requestOwnerID: "owner",
            offeredByID: "member-1",
            offeredByName: "Sam",
            skillProvided: "Bike repair",
            message: "Happy to help."
        )
        let secondOffer = SkillOffer(
            requestID: secondRequestID,
            requestOwnerID: "owner",
            offeredByID: "member-2",
            offeredByName: "Mia",
            skillProvided: "Tutoring",
            message: "I can help with this."
        )
        let repository = TestSkillSwapRepository(offers: [firstOffer, secondOffer])

        let results = try repository.fetchOffers(requestID: firstRequestID)

        XCTAssertEqual(results.map(\.id), [firstOffer.id])
    }
}
