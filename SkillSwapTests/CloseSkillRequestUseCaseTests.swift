import XCTest
@testable import SkillSwap

final class CloseSkillRequestUseCaseTests: XCTestCase {
    func test_closeSkillRequest_marksOwnedRequestClosed() throws {
        let request = makeRequest(ownerID: "me")
        let repository = TestSkillSwapRepository(requests: [request])
        let useCase = CloseSkillRequestUseCase(repository: repository)

        try useCase.execute(requestID: request.id, currentMemberID: "me")

        XCTAssertEqual(repository.requests.first?.status, .closed)
    }

    func test_closeSkillRequest_rejectsNonOwner() {
        let request = makeRequest(ownerID: "owner")
        let useCase = CloseSkillRequestUseCase(repository: TestSkillSwapRepository(requests: [request]))

        XCTAssertThrowsError(
            try useCase.execute(requestID: request.id, currentMemberID: "me")
        ) { error in
            XCTAssertEqual(error as? CloseSkillRequestError, .notRequestOwner)
        }
    }
}
