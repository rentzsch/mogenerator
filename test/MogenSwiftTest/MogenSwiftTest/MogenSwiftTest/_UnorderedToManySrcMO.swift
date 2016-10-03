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

    class func entity(_ managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext);
    }

    /// pragma mark - Life cycle methods

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _UnorderedToManySrcMO.entity(managedObjectContext)
        self.init(entity: entity!, insertInto: managedObjectContext)
    }

    /// pragma mark - Properties

    @NSManaged
    var tag: NSNumber?

    // func validateTag(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    /// pragma mark - Relationships

    @NSManaged
    var relationship: NSSet

    func relationshipSet() -> NSMutableSet! {
        self.willAccessValue(forKey: "relationship")

        let result = self.mutableSetValue(forKey: "relationship")

        self.didAccessValue(forKey: "relationship")
        return result
    }

    class func fetchAllUnorderedToManySrcs(_ managedObjectContext: NSManagedObjectContext!) -> [AnyObject] {
        return self.fetchAllUnorderedToManySrcs(managedObjectContext, error: nil)
    }

    class func fetchAllUnorderedToManySrcs(_ managedObjectContext: NSManagedObjectContext!, error outError: NSErrorPointer) -> [AnyObject] {
        let model = managedObjectContext.persistentStoreCoordinator!.managedObjectModel
        let substitutionVariables:[String : Any] = [:]

        let fetchRequest = model.fetchRequestFromTemplate(withName: "allUnorderedToManySrcs", substitutionVariables: substitutionVariables )
        assert(fetchRequest != nil, "Can't find fetch request named \"allUnorderedToManySrcs\".")

        var results:[AnyObject] = []
        do {
            
            
             results = try managedObjectContext.fetch(fetchRequest!)

        }catch let e {
            outError?.pointee = e as NSError?

            
        }

        

        return results
    }

}

extension _UnorderedToManySrcMO {

    func addRelationship(_ objects: NSSet) {
        self.relationshipSet().union(objects as Set<NSObject>)
    }

    func removeRelationship(_ objects: NSSet) {
        self.relationshipSet().minus(objects as Set<NSObject>)
    }

    func addRelationshipObject(_ value: UnorderedToManyDstMO!) {
        self.relationshipSet().add(value)
    }

    func removeRelationshipObject(_ value: UnorderedToManyDstMO!) {
        self.relationshipSet().remove(value)
    }

}

