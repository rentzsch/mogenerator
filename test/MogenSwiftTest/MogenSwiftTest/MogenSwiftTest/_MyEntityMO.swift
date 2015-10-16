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

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    /// pragma mark - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _MyEntityMO.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
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

