import Foundation
import WidgetKit

/// Writes a compact SkillSwap snapshot to the App Group so the widget can show useful information without opening Core Data directly.
struct SkillSwapWidgetPublisher {
    static let appGroupIdentifier = "group.com.zadeelsaddik.SkillSwapA3"
    static let widgetKind = "SkillSwapWidget"

    private enum Keys {
        static let activeRequestCount = "widget.activeRequestCount"
        static let incomingOfferCount = "widget.incomingOfferCount"
        static let featuredNeed = "widget.featuredNeed"
        static let featuredOffer = "widget.featuredOffer"
        static let updatedAt = "widget.updatedAt"
    }

    func publish(repository: SkillSwapRepository, memberID: String) {
        guard let defaults = UserDefaults(suiteName: Self.appGroupIdentifier) else { return }

        do {
            let requests = try repository.fetchRequests(ownerID: memberID)
            let activeRequests = requests.filter { $0.status == .open || $0.status == .matched }
            let incomingOffers = try repository.fetchIncomingOffers(requestOwnerID: memberID)
                .filter { $0.status == .pending }
            let featured = activeRequests.first

            defaults.set(activeRequests.count, forKey: Keys.activeRequestCount)
            defaults.set(incomingOffers.count, forKey: Keys.incomingOfferCount)
            defaults.set(featured?.needTitle ?? "No active requests", forKey: Keys.featuredNeed)
            defaults.set(featured?.offeredSkill ?? "Post a swap to get started", forKey: Keys.featuredOffer)
            defaults.set(Date().timeIntervalSince1970, forKey: Keys.updatedAt)

            WidgetCenter.shared.reloadTimelines(ofKind: Self.widgetKind)
        } catch {
            // Widget publishing is a presentation-side enhancement. Core domain operations must remain usable if a snapshot refresh fails.
        }
    }
}

/// Decorates the persistence boundary so every request or offer mutation refreshes the App Group snapshot and WidgetKit timeline.
final class WidgetPublishingSkillSwapRepository: SkillSwapRepository {
    private let base: SkillSwapRepository
    private let memberID: String
    private let publisher: SkillSwapWidgetPublisher

    init(
        base: SkillSwapRepository,
        memberID: String,
        publisher: SkillSwapWidgetPublisher = SkillSwapWidgetPublisher()
    ) {
        self.base = base
        self.memberID = memberID
        self.publisher = publisher
    }

    func fetchOpenRequests(excludingOwnerID: String, category: SkillCategory?) throws -> [SkillRequest] {
        try base.fetchOpenRequests(excludingOwnerID: excludingOwnerID, category: category)
    }

    func fetchRequests(ownerID: String) throws -> [SkillRequest] {
        try base.fetchRequests(ownerID: ownerID)
    }

    func fetchRequest(id: UUID) throws -> SkillRequest? {
        try base.fetchRequest(id: id)
    }

    func saveRequest(_ request: SkillRequest) throws {
        try base.saveRequest(request)
        publisher.publish(repository: base, memberID: memberID)
    }

    func updateRequest(_ request: SkillRequest) throws {
        try base.updateRequest(request)
        publisher.publish(repository: base, memberID: memberID)
    }

    func fetchOffers(requestID: UUID) throws -> [SkillOffer] {
        try base.fetchOffers(requestID: requestID)
    }

    func fetchIncomingOffers(requestOwnerID: String) throws -> [SkillOffer] {
        try base.fetchIncomingOffers(requestOwnerID: requestOwnerID)
    }

    func saveOffer(_ offer: SkillOffer) throws {
        try base.saveOffer(offer)
        publisher.publish(repository: base, memberID: memberID)
    }

    func updateOffer(_ offer: SkillOffer) throws {
        try base.updateOffer(offer)
        publisher.publish(repository: base, memberID: memberID)
    }
}
