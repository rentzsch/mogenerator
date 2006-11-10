//
//  mogeneratorTestMule_AppDelegate.h
//  mogeneratorTestMule
//
//  Created by wolf on 11/10/06.
//  Copyright __MyCompanyName__ 2006 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface mogeneratorTestMule_AppDelegate : NSObject 
{
    IBOutlet NSWindow *window;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectModel *)managedObjectModel;
- (NSManagedObjectContext *)managedObjectContext;

- (IBAction)saveAction:sender;

@end
