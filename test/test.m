#import <Cocoa/Cocoa.h>
#import "MyBaseClass.h"
#import "MOs/ParentMO.h"
#import "MOs/ChildMO.h"

#if __has_feature(objc_arc)
    #define autorelease self
#endif

int main(int argc, char *argv[]) {
    @autoreleasepool {
    
    NSManagedObjectContext *moc;
    {{
        NSURL *modelURL = [NSURL fileURLWithPath:@"test.mom"];
        assert(modelURL);
        
        NSManagedObjectModel *model = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] autorelease];
        assert(model);
        
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model] autorelease];
        assert(persistentStoreCoordinator);
        
        NSError *inMemoryStoreError = nil;
        NSPersistentStore *persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                                                      configuration:nil
                                                                                                URL:nil
                                                                                            options:nil
                                                                                              error:&inMemoryStoreError];

        assert(persistentStore);
        assert(!inMemoryStoreError);
        
        moc = [[[NSManagedObjectContext alloc] init] autorelease];
        [moc setPersistentStoreCoordinator:persistentStoreCoordinator];
        assert(moc);
    }}
    
    //--
    
    ParentMO *homer = [ParentMO insertInManagedObjectContext:moc];
    homer.humanName = homer.parentName = @"homer";
    [homer setIvar:1.0];
    
    ParentMO *marge = [ParentMO insertInManagedObjectContext:moc];
    marge.humanName = marge.parentName = @"marge";
    [marge setIvar:1.0];
    
    NSCAssert([homer.children count] == 0, nil);
    NSCAssert([marge.children count] == 0, nil);
    
    //--
    
    ChildMO *bart = [ChildMO insertInManagedObjectContext:moc];
    bart.humanName = bart.childName = @"bart";
    [bart setIvar:1.0];
    
    ChildMO *lisa = [ChildMO insertInManagedObjectContext:moc];
    lisa.humanName = lisa.childName = @"lisa";
    [lisa setIvar:1.0];

    [homer addChildrenObject:bart];
    [homer addChildrenObject:lisa];
    [marge addChildrenObject:bart];
    [marge addChildrenObject:lisa];
    
    NSCAssert([homer.children count] == 2, nil);
    NSCAssert([marge.children count] == 2, nil);
    
    //--
    
    NSError *saveError = nil;
    BOOL saveSuccess = [moc save:&saveError];
    assert(saveSuccess);
    assert(!saveError);
    
    //--
    
    }
    puts("success");
    return 0;
}
