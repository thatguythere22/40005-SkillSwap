import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var requests: [SkillRequest] = []
    @Published var errorMessage: String?

    private let browseUseCase: BrowseOpenSkillRequestsUseCase
    private let currentMemberID: String

    init(browseUseCase: BrowseOpenSkillRequestsUseCase, currentMemberID: String) {
        self.browseUseCase = browseUseCase
        self.currentMemberID = currentMemberID
    }

    func refresh() {
        do {
            requests = Array(try browseUseCase.execute(currentMemberID: currentMemberID).prefix(3))
            errorMessage = nil
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "SkillSwap could not refresh the community board."
        }
    }
}
