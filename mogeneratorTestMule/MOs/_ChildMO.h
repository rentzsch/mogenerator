// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChildMO.h instead.

#import <CoreData/CoreData.h>
#import "HumanMO.h"

extern const struct ChildMOAttributes {
	 NSString *childName;
} ChildMOAttributes;

extern const struct ChildMORelationships {
	 NSString *parent;
} ChildMORelationships;

extern const struct ChildMOFetchedProperties {
} ChildMOFetchedProperties;

@class ParentMO;



@interface ChildMOID : NSManagedObjectID {}
@end

@interface _ChildMO : HumanMO {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ChildMOID*)objectID;




@property (nonatomic, retain) NSString *childName;


//- (BOOL)validateChildName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) ParentMO* parent;

//- (BOOL)validateParent:(id*)value_ error:(NSError**)error_;




+ (NSArray*)fetchByParent:(NSManagedObjectContext*)moc_ parent:(ParentMO*)parent_ ;
+ (NSArray*)fetchByParent:(NSManagedObjectContext*)moc_ parent:(ParentMO*)parent_ error:(NSError**)error_;



@end

@interface _ChildMO (CoreDataGeneratedAccessors)

@end

@interface _ChildMO (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveChildName;
- (void)setPrimitiveChildName:(NSString*)value;





- (ParentMO*)primitiveParent;
- (void)setPrimitiveParent:(ParentMO*)value;


@end
