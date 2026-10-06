import CoreData

final class ExchangeRequestEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var ownerID: String
    @NSManaged var ownerName: String
    @NSManaged var needTitle: String
    @NSManaged var needDescriptionText: String
    @NSManaged var offeredSkill: String
    @NSManaged var categoryRaw: String
    @NSManaged var availability: String
    @NSManaged var createdAt: Date
    @NSManaged var statusRaw: String
    @NSManaged var offers: NSSet?
}

final class ExchangeOfferEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var requestID: UUID
    @NSManaged var requestOwnerID: String
    @NSManaged var offeredByID: String
    @NSManaged var offeredByName: String
    @NSManaged var skillProvided: String
    @NSManaged var message: String
    @NSManaged var createdAt: Date
    @NSManaged var statusRaw: String
    @NSManaged var request: ExchangeRequestEntity?
}

/// Creates the local Core Data store used by the SkillSwap MVP.
final class CoreDataStack {
    static let shared = CoreDataStack()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        let model = NSManagedObjectModel()

        let requestEntity = NSEntityDescription()
        requestEntity.name = "ExchangeRequestEntity"
        requestEntity.managedObjectClassName = NSStringFromClass(ExchangeRequestEntity.self)

        let offerEntity = NSEntityDescription()
        offerEntity.name = "ExchangeOfferEntity"
        offerEntity.managedObjectClassName = NSStringFromClass(ExchangeOfferEntity.self)

        requestEntity.properties = [
            Self.attribute("id", .UUIDAttributeType, optional: false),
            Self.attribute("ownerID", .stringAttributeType, optional: false),
            Self.attribute("ownerName", .stringAttributeType, optional: false),
            Self.attribute("needTitle", .stringAttributeType, optional: false),
            Self.attribute("needDescriptionText", .stringAttributeType, optional: false),
            Self.attribute("offeredSkill", .stringAttributeType, optional: false),
            Self.attribute("categoryRaw", .stringAttributeType, optional: false),
            Self.attribute("availability", .stringAttributeType, optional: false),
            Self.attribute("createdAt", .dateAttributeType, optional: false),
            Self.attribute("statusRaw", .stringAttributeType, optional: false)
        ]

        offerEntity.properties = [
            Self.attribute("id", .UUIDAttributeType, optional: false),
            Self.attribute("requestID", .UUIDAttributeType, optional: false),
            Self.attribute("requestOwnerID", .stringAttributeType, optional: false),
            Self.attribute("offeredByID", .stringAttributeType, optional: false),
            Self.attribute("offeredByName", .stringAttributeType, optional: false),
            Self.attribute("skillProvided", .stringAttributeType, optional: false),
            Self.attribute("message", .stringAttributeType, optional: false),
            Self.attribute("createdAt", .dateAttributeType, optional: false),
            Self.attribute("statusRaw", .stringAttributeType, optional: false)
        ]

        let requestToOffers = NSRelationshipDescription()
        requestToOffers.name = "offers"
        requestToOffers.destinationEntity = offerEntity
        requestToOffers.minCount = 0
        requestToOffers.maxCount = 0
        requestToOffers.deleteRule = .cascadeDeleteRule
        requestToOffers.isOptional = true

        let offerToRequest = NSRelationshipDescription()
        offerToRequest.name = "request"
        offerToRequest.destinationEntity = requestEntity
        offerToRequest.minCount = 0
        offerToRequest.maxCount = 1
        offerToRequest.deleteRule = .nullifyDeleteRule
        offerToRequest.isOptional = true

        requestToOffers.inverseRelationship = offerToRequest
        offerToRequest.inverseRelationship = requestToOffers
        requestEntity.properties.append(requestToOffers)
        offerEntity.properties.append(offerToRequest)

        model.entities = [requestEntity, offerEntity]

        container = NSPersistentContainer(name: "SkillSwapModel", managedObjectModel: model)
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error {
                assertionFailure("Core Data store failed to load: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    private static func attribute(
        _ name: String,
        _ type: NSAttributeType,
        optional: Bool
    ) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = type
        attribute.isOptional = optional
        return attribute
    }
}
