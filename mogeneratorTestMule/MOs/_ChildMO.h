// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChildMO.h instead.

#import <CoreData/CoreData.h>
#import "HumanMO.h"

@class ParentMO;

@interface ChildMOID : NSManagedObjectID {}
@end

@interface _ChildMO : HumanMO {}
+ (id)newInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ChildMOID*)objectID;



- (NSString*)childName;
- (void)setChildName:(NSString*)value_;
#if defined(MAC_OS_X_VERSION_10_5) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
@property (retain) NSString *childName;
#endif

//- (BOOL)validateChildName:(id*)value_ error:(NSError**)error_;




- (ParentMO*)parent;
- (void)setParent:(ParentMO*)value_;
//- (BOOL)validateParent:(id*)value_ error:(NSError**)error_;
#if defined(MAC_OS_X_VERSION_10_5) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
@property (retain) ParentMO* parent;
#endif


@end
