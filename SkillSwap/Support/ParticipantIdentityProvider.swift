import Foundation

/// Provides a stable local identifier for the current SkillSwap member.
final class ParticipantIdentityProvider {
    private let defaults: UserDefaults
    private let key = "skillswap.member.id"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var memberID: String {
        if let existing = defaults.string(forKey: key) {
            return existing
        }
        let generated = UUID().uuidString
        defaults.set(generated, forKey: key)
        return generated
    }
}
