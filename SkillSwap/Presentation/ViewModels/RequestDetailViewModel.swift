import Foundation
import Combine

@MainActor
final class RequestDetailViewModel: ObservableObject {
    @Published private(set) var request: SkillRequest
    @Published private(set) var offers: [SkillOffer] = []
    @Published var offerSkill = ""
    @Published var offerMessage = ""
    @Published var errorMessage: String?
    @Published var confirmationMessage: String?

    private let getOffersUseCase: GetOffersForRequestUseCase
    private let submitOfferUseCase: SubmitSkillOfferUseCase
    private let acceptOfferUseCase: AcceptSkillOfferUseCase
    private let closeRequestUseCase: CloseSkillRequestUseCase
    private let currentMemberID: String
    private let profileStore: ProfileStore
    private let reminderService: SessionReminderService

    init(
        request: SkillRequest,
        getOffersUseCase: GetOffersForRequestUseCase,
        submitOfferUseCase: SubmitSkillOfferUseCase,
        acceptOfferUseCase: AcceptSkillOfferUseCase,
        closeRequestUseCase: CloseSkillRequestUseCase,
        currentMemberID: String,
        profileStore: ProfileStore,
        reminderService: SessionReminderService
    ) {
        self.request = request
        self.getOffersUseCase = getOffersUseCase
        self.submitOfferUseCase = submitOfferUseCase
        self.acceptOfferUseCase = acceptOfferUseCase
        self.closeRequestUseCase = closeRequestUseCase
        self.currentMemberID = currentMemberID
        self.profileStore = profileStore
        self.reminderService = reminderService
    }

    var isOwner: Bool { request.ownerID == currentMemberID }

    func refreshOffers() {
        do {
            offers = try getOffersUseCase.execute(requestID: request.id)
            errorMessage = nil
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Offers could not be loaded."
        }
    }

    func submitOffer() {
        do {
            _ = try submitOfferUseCase.execute(
                requestID: request.id,
                memberID: currentMemberID,
                memberName: profileStore.displayName,
                skillProvided: offerSkill,
                message: offerMessage
            )
            offerSkill = ""
            offerMessage = ""
            confirmationMessage = "Your offer has been sent."
            refreshOffers()
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Your offer could not be sent."
        }
    }

    func accept(_ offer: SkillOffer) {
        do {
            try acceptOfferUseCase.execute(requestID: request.id, offerID: offer.id, currentMemberID: currentMemberID)
            request.status = .matched
            confirmationMessage = "Exchange matched with \(offer.offeredByName)."
            refreshOffers()
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "This offer could not be accepted."
        }
    }

    func closeRequest() {
        do {
            try closeRequestUseCase.execute(requestID: request.id, currentMemberID: currentMemberID)
            request.status = .closed
            confirmationMessage = "This request is now closed."
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "This request could not be closed."
        }
    }

    func scheduleReminder(for offer: SkillOffer) async {
        let allowed = await reminderService.requestPermission()
        guard allowed else {
            errorMessage = "Notifications are disabled. Allow notifications in Settings to receive session reminders."
            return
        }
        do {
            try await reminderService.scheduleDemoReminder(
                partnerName: offer.offeredByName,
                needSkill: request.needTitle,
                offeredSkill: request.offeredSkill
            )
            confirmationMessage = "Demo session reminder scheduled for a few seconds from now."
        } catch {
            errorMessage = "SkillSwap could not schedule the reminder. Please try again."
        }
    }
}
