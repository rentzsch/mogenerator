// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HumanMO.h instead.

#import <CoreData/CoreData.h>
#import "MyBaseClass.h"

@class NSManagedObject;

@interface HumanMOID : NSManagedObjectID {}
@end

@interface _HumanMO : MyBaseClass {}
+ (id)newInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (HumanMOID*)objectID;





- (NSString*)humanName;
- (void)setHumanName:(NSString*)value_;
#if defined(MAC_OS_X_VERSION_10_5) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
@property (retain) NSString *humanName;
#endif

//- (BOOL)validateHumanName:(id*)value_ error:(NSError**)error_;



- (NSData*)hairColorStorage;
- (void)setHairColorStorage:(NSData*)value_;
#if defined(MAC_OS_X_VERSION_10_5) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
@property (retain) NSData *hairColorStorage;
#endif

//- (BOOL)validateHairColorStorage:(id*)value_ error:(NSError**)error_;




- (NSManagedObject*)meaninglessRelationship;
- (void)setMeaninglessRelationship:(NSManagedObject*)value_;
//- (BOOL)validateMeaninglessRelationship:(id*)value_ error:(NSError**)error_;
#if defined(MAC_OS_X_VERSION_10_5) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
@property (retain) NSManagedObject* meaninglessRelationship;
#endif


@end
