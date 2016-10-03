import Cocoa
import XCTest
@testable import MogenSwiftTest

class MogenSwiftTestTests: XCTestCase {
    func newMoc() -> (NSManagedObjectContext) {
        let momURL : URL = Bundle.main.url(forResource: "MogenSwiftTest", withExtension: "momd")!
        let mom : NSManagedObjectModel = NSManagedObjectModel(contentsOf: momURL)!
        let psc : NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: mom);
        let ps : NSPersistentStore = psc.addPersistentStoreWithType(
            NSInMemoryStoreType,
            configuration: nil,
            URL: nil,
            options: nil,
            error: nil)!
        let moc : NSManagedObjectContext = NSManagedObjectContext()
        moc.persistentStoreCoordinator = psc
        return moc
    }
    
    func testUnorderedToMany() {
        let moc = newMoc()
        
        let a = MyEntityMO(managedObjectContext: moc)
        println("^^before: \(a)")
        a.stringAttribute = "fred";
        a.integerAttribute = 42
        println("^^after 1: \(a)")
        a.integerAttribute = nil
        println("^^after 2: \(a)")
        XCTAssert(moc.save(nil), "")

        
        //--
        
        var srcs = UnorderedToManySrcMO.fetchAllUnorderedToManySrcs(moc)
        XCTAssertEqual(srcs.count, 0, "")
        
        var dsts = UnorderedToManyDstMO.fetchAllUnorderedToManyDsts(moc)
        XCTAssertEqual(dsts.count, 0, "")
        
        //--
        
        let src : UnorderedToManySrcMO = UnorderedToManySrcMO(
            entity: NSEntityDescription.entityForName_workaround("UnorderedToManySrc", inManagedObjectContext:moc),
            insertIntoManagedObjectContext: moc)
        
        //--
        
        srcs = UnorderedToManySrcMO.fetchAllUnorderedToManySrcs(moc)
        XCTAssertEqual(srcs.count, 1, "")
        XCTAssert(moc.save(nil), "")
        
        //--
        
        var dst1 : UnorderedToManyDstMO = UnorderedToManyDstMO(
            entity: NSEntityDescription.entityForName_workaround("UnorderedToManyDst", inManagedObjectContext:moc),
            insertIntoManagedObjectContext: moc)
        
        var dst2 : UnorderedToManyDstMO = UnorderedToManyDstMO(
            entity: NSEntityDescription.entityForName_workaround("UnorderedToManyDst", inManagedObjectContext:moc),
            insertIntoManagedObjectContext: moc)
        
        src.addRelationshipObject(dst1)
        src.addRelationshipObject(dst2)
        
        /*UnorderedToManyDstMO(managedObjectContext: moc)
        XCTAssert(moc.save(nil), "")*/
        
        /*
        //--
        
        var src = UnorderedToManyDstMO(managedObjectContext: moc)
        src.tag = 42
        
        var dst = UnorderedToManyDestinationMO(managedObjectContext: moc)
        dst.tag = 43
        
        src.addRelationshipObject(dst)*/
        
        //
        
        //--
        
    }
}

extension NSEntityDescription {
    class func entityForName_workaround(_ entityName: String!, inManagedObjectContext context: NSManagedObjectContext!) -> NSEntityDescription! {
        let entities = context.persistentStoreCoordinator!.managedObjectModel.entitiesByName;
        let keys = Array(entities.keys)
        var result : NSEntityDescription?
        for (key, value) in entities {
            if key == entityName {
                result = value as? NSEntityDescription
            }
        }
        return result
    }
}
