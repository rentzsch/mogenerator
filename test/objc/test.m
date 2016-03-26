@import Cocoa;

#import "../MOs/MyBaseClass.h"
#import "../MOs/ParentMO.h"
#import "../MOs/ChildMO.h"
#import "../MOs/Gender.h"

int main(int argc, char *argv[]) {
    @autoreleasepool {
    NSManagedObjectContext *moc;
    {{
        NSURL *modelURL = [NSURL fileURLWithPath:@"test.mom"];
        assert(modelURL);

        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        assert(model);

        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        assert(persistentStoreCoordinator);

        NSError *inMemoryStoreError = nil;
        NSPersistentStore *persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                                                      configuration:nil
                                                                                                URL:nil
                                                                                            options:nil
                                                                                              error:&inMemoryStoreError];

        assert(persistentStore);
        assert(!inMemoryStoreError);

        moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        moc.persistentStoreCoordinator = persistentStoreCoordinator;
        assert(moc);
    }}

    //--

    ParentMO *homer = [ParentMO insertInManagedObjectContext:moc];
    homer.humanName = homer.parentName = @"homer";
    [homer setIvar:1.0];
    homer.genderValue = Gender_Male;

    ParentMO *marge = [ParentMO insertInManagedObjectContext:moc];
    marge.humanName = marge.parentName = @"marge";
    [marge setIvar:1.0];
    marge.genderValue = Gender_Female;

    assert([homer.children count] == 0);
    assert([marge.children count] == 0);

    //--

    ChildMO *bart = [ChildMO insertInManagedObjectContext:moc];
    bart.humanName = bart.childName = @"bart";
    [bart setIvar:1.0];
    bart.type = [NSNumber numberWithInt:64];
    bart.typeValue++;

    ChildMO *lisa = [ChildMO insertInManagedObjectContext:moc];
    lisa.humanName = lisa.childName = @"lisa";
    [lisa setIvar:1.0];

    //--

    NSError *saveError = nil;
    BOOL saveSuccess = [moc save:&saveError];
    assert(saveSuccess);
    assert(!saveError);

    //--

    assert(homer.genderValue == Gender_Male);
    assert(marge.genderValue == Gender_Female);
    assert(bart.genderValue == Gender_Undefined);
    assert([GenderToString(homer.genderValue) isEqualToString:@"Gender_Male"]);
    }
    puts("success");
    return 0;
}
