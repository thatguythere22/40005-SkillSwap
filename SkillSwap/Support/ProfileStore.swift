import Foundation
import Combine

/// Stores lightweight profile preferences that do not require relational persistence.
@MainActor
final class ProfileStore: ObservableObject {
    @Published var displayName: String {
        didSet { defaults.set(displayName, forKey: "skillswap.profile.name") }
    }

    @Published var headline: String {
        didSet { defaults.set(headline, forKey: "skillswap.profile.headline") }
    }

    @Published var skills: String {
        didSet { defaults.set(skills, forKey: "skillswap.profile.skills") }
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        displayName = defaults.string(forKey: "skillswap.profile.name") ?? "Zade"
        headline = defaults.string(forKey: "skillswap.profile.headline") ?? "Happy to swap practical help and study skills"
        skills = defaults.string(forKey: "skillswap.profile.skills") ?? "Tech help, study support"
    }
}
