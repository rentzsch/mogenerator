// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to UnorderedToManySrcMO.swift instead.

import CoreData

enum UnorderedToManySrcMOAttributes: String {
    case tag = "tag"
}

enum UnorderedToManySrcMORelationships: String {
    case relationship = "relationship"
}

@objc
class _UnorderedToManySrcMO: NSManagedObject {

    /// pragma mark - Class methods

    class func entityName () -> String {
        return "UnorderedToManySrc"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    /// pragma mark - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _UnorderedToManySrcMO.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    /// pragma mark - Properties

    @NSManaged
    var tag: NSNumber?

    // func validateTag(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    /// pragma mark - Relationships

    @NSManaged
    var relationship: NSSet

    func relationshipSet() -> NSMutableSet! {
        self.willAccessValueForKey("relationship")

        let result = self.mutableSetValueForKey("relationship")

        self.didAccessValueForKey("relationship")
        return result
    }

    class func fetchAllUnorderedToManySrcs(managedObjectContext: NSManagedObjectContext!) -> [AnyObject] {
        return self.fetchAllUnorderedToManySrcs(managedObjectContext, error: nil)
    }

    class func fetchAllUnorderedToManySrcs(managedObjectContext: NSManagedObjectContext!, error outError: NSErrorPointer) -> [AnyObject] {
        let model = managedObjectContext.persistentStoreCoordinator!.managedObjectModel
        let substitutionVariables = [:]

        let fetchRequest = model.fetchRequestFromTemplateWithName("allUnorderedToManySrcs", substitutionVariables: substitutionVariables as [NSObject : AnyObject])
        assert(fetchRequest != nil, "Can't find fetch request named \"allUnorderedToManySrcs\".")

        var error: NSError? = nil
        let results = managedObjectContext.executeFetchRequest(fetchRequest!, error: &error)

        if (error != nil) {
            outError.memory = error
        }

        return results!
    }

}

extension _UnorderedToManySrcMO {

    func addRelationship(objects: NSSet) {
        self.relationshipSet().unionSet(objects as Set<NSObject>)
    }

    func removeRelationship(objects: NSSet) {
        self.relationshipSet().minusSet(objects as Set<NSObject>)
    }

    func addRelationshipObject(value: UnorderedToManyDstMO!) {
        self.relationshipSet().addObject(value)
    }

    func removeRelationshipObject(value: UnorderedToManyDstMO!) {
        self.relationshipSet().removeObject(value)
    }

}

