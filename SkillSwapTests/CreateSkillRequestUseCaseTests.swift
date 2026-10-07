import XCTest
@testable import SkillSwap

final class CreateSkillRequestUseCaseTests: XCTestCase {
    func test_createSkillRequest_savesValidTwoSidedExchange() throws {
        let repository = TestSkillSwapRepository()
        let useCase = CreateSkillRequestUseCase(repository: repository)

        let result = try useCase.execute(
            ownerID: "me",
            ownerName: "Zade",
            needTitle: "Bike repair",
            needDescription: "My chain keeps slipping.",
            offeredSkill: "Photoshop help",
            category: .practical,
            availability: "Weeknights"
        )

        XCTAssertEqual(result.needTitle, "Bike repair")
        XCTAssertEqual(repository.requests.count, 1)
    }

    func test_createSkillRequest_rejectsSameSkillOnBothSides() {
        let repository = TestSkillSwapRepository()
        let useCase = CreateSkillRequestUseCase(repository: repository)

        XCTAssertThrowsError(
            try useCase.execute(
                ownerID: "me",
                ownerName: "Zade",
                needTitle: "Guitar",
                needDescription: "Help me practise.",
                offeredSkill: "guitar",
                category: .music,
                availability: "Friday"
            )
        ) { error in
            XCTAssertEqual(error as? CreateSkillRequestError, .sameSkillOnBothSides)
        }
    }

    func test_createSkillRequest_rejectsMissingDescription() {
        let useCase = CreateSkillRequestUseCase(repository: TestSkillSwapRepository())
        XCTAssertThrowsError(
            try useCase.execute(
                ownerID: "me",
                ownerName: "Zade",
                needTitle: "Excel",
                needDescription: "   ",
                offeredSkill: "Essay proofreading",
                category: .study,
                availability: ""
            )
        ) { error in
            XCTAssertEqual(error as? CreateSkillRequestError, .missingDescription)
        }
    }
}
