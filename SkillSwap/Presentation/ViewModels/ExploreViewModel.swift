import Foundation
import Combine

@MainActor
final class ExploreViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedCategory: SkillCategory?
    @Published private(set) var requests: [SkillRequest] = []
    @Published var errorMessage: String?

    private let browseUseCase: BrowseOpenSkillRequestsUseCase
    private let currentMemberID: String

    init(browseUseCase: BrowseOpenSkillRequestsUseCase, currentMemberID: String) {
        self.browseUseCase = browseUseCase
        self.currentMemberID = currentMemberID
    }

    var visibleRequests: [SkillRequest] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return requests }
        return requests.filter {
            $0.needTitle.localizedCaseInsensitiveContains(query) ||
            $0.offeredSkill.localizedCaseInsensitiveContains(query) ||
            $0.needDescription.localizedCaseInsensitiveContains(query)
        }
    }

    func refresh() {
        do {
            requests = try browseUseCase.execute(currentMemberID: currentMemberID, category: selectedCategory)
            errorMessage = nil
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "SkillSwap could not load requests."
        }
    }
}
