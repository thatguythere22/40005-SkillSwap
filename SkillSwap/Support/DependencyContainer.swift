import Foundation

/// Builds the repository, use cases, and presentation dependencies shared by the app.
@MainActor
final class DependencyContainer {
    let repository: SkillSwapRepository
    let identityProvider: ParticipantIdentityProvider
    let profileStore: ProfileStore
    let reminderService: SessionReminderService

    init(
        repository: SkillSwapRepository? = nil,
        identityProvider: ParticipantIdentityProvider? = nil,
        profileStore: ProfileStore? = nil,
        reminderService: SessionReminderService? = nil
    ) {
        let resolvedIdentity = identityProvider ?? ParticipantIdentityProvider()
        self.identityProvider = resolvedIdentity
        self.profileStore = profileStore ?? ProfileStore()
        self.reminderService = reminderService ?? SessionReminderService()

        if let repository {
            self.repository = repository
        } else {
            let coreDataRepository = CoreDataSkillSwapRepository()

            DemoDataSeeder(repository: coreDataRepository)
                .seedIfNeeded(currentMemberID: resolvedIdentity.memberID)

            self.repository = coreDataRepository
        }
    }

    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            browseUseCase: BrowseOpenSkillRequestsUseCase(repository: repository),
            currentMemberID: identityProvider.memberID
        )
    }

    func makeExploreViewModel() -> ExploreViewModel {
        ExploreViewModel(
            browseUseCase: BrowseOpenSkillRequestsUseCase(repository: repository),
            currentMemberID: identityProvider.memberID
        )
    }

    func makeCreateRequestViewModel() -> CreateRequestViewModel {
        CreateRequestViewModel(
            createUseCase: CreateSkillRequestUseCase(repository: repository),
            memberID: identityProvider.memberID,
            profileStore: profileStore
        )
    }

    func makeActivityViewModel() -> ActivityViewModel {
        ActivityViewModel(
            myRequestsUseCase: GetMySkillRequestsUseCase(repository: repository),
            incomingOffersUseCase: GetIncomingOffersUseCase(repository: repository),
            memberID: identityProvider.memberID
        )
    }

    func makeRequestDetailViewModel(request: SkillRequest) -> RequestDetailViewModel {
        RequestDetailViewModel(
            request: request,
            getOffersUseCase: GetOffersForRequestUseCase(repository: repository),
            submitOfferUseCase: SubmitSkillOfferUseCase(repository: repository),
            acceptOfferUseCase: AcceptSkillOfferUseCase(repository: repository),
            closeRequestUseCase: CloseSkillRequestUseCase(repository: repository),
            currentMemberID: identityProvider.memberID,
            profileStore: profileStore,
            reminderService: reminderService
        )
    }
}
