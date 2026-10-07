import CoreData
import Foundation

/// Core Data implementation of SkillSwap's persistence boundary.
final class CoreDataSkillSwapRepository: SkillSwapRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.container.viewContext) {
        self.context = context
    }

    func fetchOpenRequests(excludingOwnerID: String, category: SkillCategory?) throws -> [SkillRequest] {
        let request = NSFetchRequest<ExchangeRequestEntity>(entityName: "ExchangeRequestEntity")
        var predicates: [NSPredicate] = [
            NSPredicate(format: "statusRaw == %@", SkillRequestStatus.open.rawValue),
            NSPredicate(format: "ownerID != %@", excludingOwnerID)
        ]
        if let category {
            predicates.append(NSPredicate(format: "categoryRaw == %@", category.rawValue))
        }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        let entities = try context.fetch(request)
        var results: [SkillRequest] = []

        for entity in entities {
            if let mapped = Self.mapRequest(entity) {
                results.append(mapped)
            }
        }

        return results
    }

    func fetchRequests(ownerID: String) throws -> [SkillRequest] {
        let request = NSFetchRequest<ExchangeRequestEntity>(entityName: "ExchangeRequestEntity")
        request.predicate = NSPredicate(format: "ownerID == %@", ownerID)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        let entities = try context.fetch(request)
        var results: [SkillRequest] = []

        for entity in entities {
            if let mapped = Self.mapRequest(entity) {
                results.append(mapped)
            }
        }

        return results
    }

    func fetchRequest(id: UUID) throws -> SkillRequest? {
        guard let entity = try fetchRequestEntity(id: id) else { return nil }
        return Self.mapRequest(entity)
    }

    func saveRequest(_ request: SkillRequest) throws {
        let entity = ExchangeRequestEntity(context: context)
        Self.apply(request, to: entity)
        try context.save()
    }

    func updateRequest(_ request: SkillRequest) throws {
        guard let entity = try fetchRequestEntity(id: request.id) else { return }
        Self.apply(request, to: entity)
        try context.save()
    }

    func fetchOffers(requestID: UUID) throws -> [SkillOffer] {
        let request = NSFetchRequest<ExchangeOfferEntity>(entityName: "ExchangeOfferEntity")
        request.predicate = NSPredicate(format: "requestID == %@", requestID as NSUUID)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        let entities = try context.fetch(request)
        var results: [SkillOffer] = []

        for entity in entities {
            if let mapped = Self.mapOffer(entity) {
                results.append(mapped)
            }
        }

        return results
    }

    func fetchIncomingOffers(requestOwnerID: String) throws -> [SkillOffer] {
        let request = NSFetchRequest<ExchangeOfferEntity>(entityName: "ExchangeOfferEntity")
        request.predicate = NSPredicate(format: "requestOwnerID == %@", requestOwnerID)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        let entities = try context.fetch(request)
        var results: [SkillOffer] = []

        for entity in entities {
            if let mapped = Self.mapOffer(entity) {
                results.append(mapped)
            }
        }

        return results
    }

    func saveOffer(_ offer: SkillOffer) throws {
        let entity = ExchangeOfferEntity(context: context)
        Self.apply(offer, to: entity)
        entity.request = try fetchRequestEntity(id: offer.requestID)
        try context.save()
    }

    func updateOffer(_ offer: SkillOffer) throws {
        guard let entity = try fetchOfferEntity(id: offer.id) else { return }
        Self.apply(offer, to: entity)
        try context.save()
    }

    private func fetchRequestEntity(id: UUID) throws -> ExchangeRequestEntity? {
        let request = NSFetchRequest<ExchangeRequestEntity>(entityName: "ExchangeRequestEntity")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id as NSUUID)
        return try context.fetch(request).first
    }

    private func fetchOfferEntity(id: UUID) throws -> ExchangeOfferEntity? {
        let request = NSFetchRequest<ExchangeOfferEntity>(entityName: "ExchangeOfferEntity")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id as NSUUID)
        return try context.fetch(request).first
    }

    private static func apply(_ request: SkillRequest, to entity: ExchangeRequestEntity) {
        entity.id = request.id
        entity.ownerID = request.ownerID
        entity.ownerName = request.ownerName
        entity.needTitle = request.needTitle
        entity.needDescriptionText = request.needDescription
        entity.offeredSkill = request.offeredSkill
        entity.categoryRaw = request.category.rawValue
        entity.availability = request.availability
        entity.createdAt = request.createdAt
        entity.statusRaw = request.status.rawValue
    }

    private static func apply(_ offer: SkillOffer, to entity: ExchangeOfferEntity) {
        entity.id = offer.id
        entity.requestID = offer.requestID
        entity.requestOwnerID = offer.requestOwnerID
        entity.offeredByID = offer.offeredByID
        entity.offeredByName = offer.offeredByName
        entity.skillProvided = offer.skillProvided
        entity.message = offer.message
        entity.createdAt = offer.createdAt
        entity.statusRaw = offer.status.rawValue
    }

    private static func mapRequest(_ entity: ExchangeRequestEntity) -> SkillRequest? {
        guard
            let category = SkillCategory(rawValue: entity.categoryRaw),
            let status = SkillRequestStatus(rawValue: entity.statusRaw)
        else { return nil }

        return SkillRequest(
            id: entity.id,
            ownerID: entity.ownerID,
            ownerName: entity.ownerName,
            needTitle: entity.needTitle,
            needDescription: entity.needDescriptionText,
            offeredSkill: entity.offeredSkill,
            category: category,
            availability: entity.availability,
            createdAt: entity.createdAt,
            status: status
        )
    }

    private static func mapOffer(_ entity: ExchangeOfferEntity) -> SkillOffer? {
        guard let status = SkillOfferStatus(rawValue: entity.statusRaw) else { return nil }
        return SkillOffer(
            id: entity.id,
            requestID: entity.requestID,
            requestOwnerID: entity.requestOwnerID,
            offeredByID: entity.offeredByID,
            offeredByName: entity.offeredByName,
            skillProvided: entity.skillProvided,
            message: entity.message,
            createdAt: entity.createdAt,
            status: status
        )
    }
}
