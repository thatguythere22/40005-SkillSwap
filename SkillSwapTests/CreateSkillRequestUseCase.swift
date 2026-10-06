import Foundation

enum CreateSkillRequestError: LocalizedError, Equatable {
    case missingNeed
    case missingOfferedSkill
    case sameSkillOnBothSides
    case missingDescription
    case unableToSave

    var errorDescription: String? {
        switch self {
        case .missingNeed:
            "Describe the skill or help you need before posting."
        case .missingOfferedSkill:
            "Add a skill you can offer in return so the exchange is clear."
        case .sameSkillOnBothSides:
            "The skill you need and the skill you offer should be different."
        case .missingDescription:
            "Add a short description so other people know what kind of help you need."
        case .unableToSave:
            "SkillSwap could not save this request. Please try again."
        }
    }
}

/// Creates a new two-sided skill exchange request after enforcing the rules that make a swap meaningful.
struct CreateSkillRequestUseCase {
    let repository: SkillSwapRepository

    func execute(
        ownerID: String,
        ownerName: String,
        needTitle: String,
        needDescription: String,
        offeredSkill: String,
        category: SkillCategory,
        availability: String
    ) throws -> SkillRequest {
        let need = needTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let description = needDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        let offered = offeredSkill.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !need.isEmpty else { throw CreateSkillRequestError.missingNeed }
        guard !offered.isEmpty else { throw CreateSkillRequestError.missingOfferedSkill }
        guard !description.isEmpty else { throw CreateSkillRequestError.missingDescription }
        guard need.caseInsensitiveCompare(offered) != .orderedSame else {
            throw CreateSkillRequestError.sameSkillOnBothSides
        }

        let request = SkillRequest(
            ownerID: ownerID,
            ownerName: ownerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Community member" : ownerName,
            needTitle: need,
            needDescription: description,
            offeredSkill: offered,
            category: category,
            availability: availability.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        do {
            try repository.saveRequest(request)
            return request
        } catch {
            throw CreateSkillRequestError.unableToSave
        }
    }
}
