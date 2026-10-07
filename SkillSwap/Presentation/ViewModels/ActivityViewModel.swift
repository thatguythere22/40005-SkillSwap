import Foundation
import Combine

@MainActor
final class ActivityViewModel: ObservableObject {
    @Published private(set) var requests: [SkillRequest] = []
    @Published private(set) var offers: [SkillOffer] = []
    @Published var errorMessage: String?

    private let myRequestsUseCase: GetMySkillRequestsUseCase
    private let incomingOffersUseCase: GetIncomingOffersUseCase
    private let memberID: String

    init(
        myRequestsUseCase: GetMySkillRequestsUseCase,
        incomingOffersUseCase: GetIncomingOffersUseCase,
        memberID: String
    ) {
        self.myRequestsUseCase = myRequestsUseCase
        self.incomingOffersUseCase = incomingOffersUseCase
        self.memberID = memberID
    }

    func refresh() {
        do {
            requests = try myRequestsUseCase.execute(memberID: memberID)
            offers = try incomingOffersUseCase.execute(memberID: memberID)
            errorMessage = nil
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Your SkillSwap activity could not be loaded."
        }
    }
}
