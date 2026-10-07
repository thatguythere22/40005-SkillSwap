import Foundation
import Combine

@MainActor
final class CreateRequestViewModel: ObservableObject {
    @Published var needTitle = ""
    @Published var needDescription = ""
    @Published var offeredSkill = ""
    @Published var category: SkillCategory = .study
    @Published var availability = ""
    @Published var errorMessage: String?
    @Published var successMessage: String?

    private let createUseCase: CreateSkillRequestUseCase
    private let memberID: String
    private let profileStore: ProfileStore

    init(createUseCase: CreateSkillRequestUseCase, memberID: String, profileStore: ProfileStore) {
        self.createUseCase = createUseCase
        self.memberID = memberID
        self.profileStore = profileStore
    }

    func post() {
        do {
            _ = try createUseCase.execute(
                ownerID: memberID,
                ownerName: profileStore.displayName,
                needTitle: needTitle,
                needDescription: needDescription,
                offeredSkill: offeredSkill,
                category: category,
                availability: availability
            )
            errorMessage = nil
            successMessage = "Your skill request is now on the community board."
            needTitle = ""
            needDescription = ""
            offeredSkill = ""
            availability = ""
            category = .study
        } catch {
            successMessage = nil
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "SkillSwap could not post this request."
        }
    }
}
