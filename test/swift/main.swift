import Cocoa
import CoreData

struct CoreDataStore {
    let moc: NSManagedObjectContext

    init() {
        let modelURL = URL(fileURLWithPath: "test.mom")
        let model = NSManagedObjectModel(contentsOf: modelURL as URL)
        let psc = NSPersistentStoreCoordinator(managedObjectModel: model!)

        do {
            let _ = try psc.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
          assertionFailure("Can't bring up PSC")
        }

        moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = psc
    }
}

let dataStore = CoreDataStore()
let moc = dataStore.moc
//
let homer = ParentMO(context: moc)
homer.humanName = "homer"
homer.parentName = homer.humanName
homer.ivar = 1.0
homer.gender = NSNumber(value: Gender.Male.rawValue)

let marge = ParentMO(context: moc)
marge.humanName = "marge"
marge.parentName = marge.humanName
marge.ivar = 1.0
marge.gender = NSNumber(value: Gender.Female.rawValue)

assert(homer.children!.count == 0)
assert(marge.children!.count == 0)

let bart = ChildMO(context: moc)
bart.humanName = "bart"
bart.childName = bart.humanName
bart.ivar = 1.0
bart.type = 64

let lisa = ChildMO(context: moc)
lisa.humanName = "lisa"
lisa.childName = lisa.humanName
lisa.ivar = 1.0

do {
    try moc.save()
    assert(Gender(rawValue: homer.gender.intValue) == .Male)
    assert(Gender(rawValue: marge.gender.intValue) == .Female)
    assert(Gender(rawValue: bart.gender.intValue) == .Undefined)
    assert(Gender(rawValue: homer.gender.intValue)!.toString() == "Male")

} catch {
    assertionFailure("Failed to save")
}

print("Success")
