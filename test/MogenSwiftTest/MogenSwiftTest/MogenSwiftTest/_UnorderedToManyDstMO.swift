// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to UnorderedToManyDstMO.swift instead.

import CoreData

enum UnorderedToManyDstMOAttributes: String {
    case tag = "tag"
}

enum UnorderedToManyDstMORelationships: String {
    case relationship = "relationship"
}

@objc
class _UnorderedToManyDstMO: NSManagedObject {

    /// pragma mark - Class methods

    class func entityName () -> String {
        return "UnorderedToManyDst"
    }

    class func entity(_ managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext);
    }

    /// pragma mark - Life cycle methods

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _UnorderedToManyDstMO.entity(managedObjectContext)
        self.init(entity: entity!, insertInto: managedObjectContext)
    }

    /// pragma mark - Properties

    @NSManaged
    var tag: NSNumber?

    // func validateTag(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    /// pragma mark - Relationships

    @NSManaged
    var relationship: UnorderedToManySrcMO

    // func validateRelationship(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

}

