#import <Cocoa/Cocoa.h>
#import "MyBaseClass.h"
#import "MOs/ParentMO.h"
#import "MOs/ChildMO.h"
#import "TestProtocol.h"

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

    ParentMO *protocolMO = [ParentMO insertInManagedObjectContext:moc];
    protocolMO.myTransformableWithProtocol = [TestProtocol new];

#if 0
    /* Unforunately this section raises the following internal exception on 10.8.0/Xcode 4.5-DP4:
     2012-08-30 16:01:12.351 test[15090:707] *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[NSSet intersectsSet:]: set argument is not an NSSet'
     *** First throw call stack:
     (
     0   CoreFoundation                      0x00007fff8c9b1716 __exceptionPreprocess + 198
     1   libobjc.A.dylib                     0x00007fff94dee470 objc_exception_throw + 43
     2   CoreFoundation                      0x00007fff8ca4b21f -[NSSet intersectsSet:] + 927
     3   Foundation                          0x00007fff8e502085 NSKeyValueWillChangeBySetMutation + 359
     4   Foundation                          0x00007fff8e5549d0 NSKeyValueWillChange + 379
     5   Foundation                          0x00007fff8e501f0f -[NSObject(NSKeyValueObserverNotification) willChangeValueForKey:withSetMutation:usingObjects:] + 318
     6   CoreData                            0x00007fff95e697e5 _sharedIMPL_addObjectToSet_core + 165
     7   test                                0x000000010d44ee6e main + 2606
     8   libdyld.dylib                       0x00007fff977127e1 start + 0
     )
     libc++abi.dylib: terminate called throwing an exception
     Abort trap: 6
     */
    [homer addChildrenObject:bart];
    [homer addChildrenObject:lisa];
    [marge addChildrenObject:bart];
    [marge addChildrenObject:lisa];
    
    NSCAssert([homer.children count] == 2, nil);
    NSCAssert([marge.children count] == 2, nil);
#endif
    
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
