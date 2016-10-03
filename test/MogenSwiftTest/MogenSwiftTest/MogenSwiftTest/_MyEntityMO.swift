// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MyEntityMO.swift instead.

import CoreData

enum MyEntityMOAttributes: String {
    case integerAttribute = "integerAttribute"
    case stringAttribute = "stringAttribute"
}

@objc
class _MyEntityMO: NSManagedObject {

    /// pragma mark - Class methods

    class func entityName () -> String {
        return "MyEntity"
    }

    class func entity(_ managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext);
    }

    /// pragma mark - Life cycle methods

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _MyEntityMO.entity(managedObjectContext)
        self.init(entity: entity!, insertInto: managedObjectContext)
    }

    /// pragma mark - Properties

    @NSManaged
    var integerAttribute: NSNumber?

    // func validateIntegerAttribute(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var stringAttribute: String

    // func validateStringAttribute(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    /// pragma mark - Relationships

}

