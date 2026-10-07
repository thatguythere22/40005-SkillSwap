import XCTest
@testable import SkillSwap

final class BrowseOpenSkillRequestsUseCaseTests: XCTestCase {
    func test_browseOpenRequests_excludesCurrentMembersOwnPosts() throws {
        let repository = TestSkillSwapRepository(requests: [
            makeRequest(ownerID: "me"),
            makeRequest(ownerID: "other")
        ])
        let useCase = BrowseOpenSkillRequestsUseCase(repository: repository)

        let results = try useCase.execute(currentMemberID: "me")

        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.ownerID, "other")
    }

    func test_browseOpenRequests_filtersBySkillCategory() throws {
        let repository = TestSkillSwapRepository(requests: [
            makeRequest(ownerID: "a", category: .study),
            makeRequest(ownerID: "b", category: .music)
        ])
        let useCase = BrowseOpenSkillRequestsUseCase(repository: repository)

        let results = try useCase.execute(currentMemberID: "me", category: .music)

        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.category, .music)
    }
}
