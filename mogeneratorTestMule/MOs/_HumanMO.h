// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HumanMO.h instead.

#import <CoreData/CoreData.h>
#import "MyBaseClass.h"

extern const struct HumanMOAttributes {
	 NSString *hairColor;
	 NSString *hairColorStorage;
	 NSString *humanName;
} HumanMOAttributes;

extern const struct HumanMORelationships {
	 NSString *meaninglessRelationship;
} HumanMORelationships;

extern const struct HumanMOFetchedProperties {
} HumanMOFetchedProperties;

@class NSManagedObject;





@interface HumanMOID : NSManagedObjectID {}
@end

@interface _HumanMO : MyBaseClass {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (HumanMOID*)objectID;






@property (nonatomic, retain) NSData *hairColorStorage;


//- (BOOL)validateHairColorStorage:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *humanName;


//- (BOOL)validateHumanName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSManagedObject* meaninglessRelationship;

//- (BOOL)validateMeaninglessRelationship:(id*)value_ error:(NSError**)error_;




+ (id)fetchOneByHumanName:(NSManagedObjectContext*)moc_ humanName:(NSString*)humanName_ ;
+ (id)fetchOneByHumanName:(NSManagedObjectContext*)moc_ humanName:(NSString*)humanName_ error:(NSError**)error_;



+ (NSArray*)fetchAllHumans:(NSManagedObjectContext*)moc_ ;
+ (NSArray*)fetchAllHumans:(NSManagedObjectContext*)moc_ error:(NSError**)error_;



+ (NSArray*)fetchByHumanName:(NSManagedObjectContext*)moc_ humanName:(NSString*)humanName_ ;
+ (NSArray*)fetchByHumanName:(NSManagedObjectContext*)moc_ humanName:(NSString*)humanName_ error:(NSError**)error_;



@end

@interface _HumanMO (CoreDataGeneratedAccessors)

@end

@interface _HumanMO (CoreDataGeneratedPrimitiveAccessors)




- (NSData*)primitiveHairColorStorage;
- (void)setPrimitiveHairColorStorage:(NSData*)value;




- (NSString*)primitiveHumanName;
- (void)setPrimitiveHumanName:(NSString*)value;





- (NSManagedObject*)primitiveMeaninglessRelationship;
- (void)setPrimitiveMeaninglessRelationship:(NSManagedObject*)value;


@end
