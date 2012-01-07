// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ParentMO.h instead.

#import <CoreData/CoreData.h>
#import "HumanMO.h"

extern const struct ParentMOAttributes {
	 NSString *myBinaryData;
	 NSString *myBoolean;
	 NSString *myDate;
	 NSString *myDecimal;
	 NSString *myDouble;
	 NSString *myFloat;
	 NSString *myInt16;
	 NSString *myInt16Transient;
	 NSString *myInt32;
	 NSString *myInt64;
	 NSString *myString;
	 NSString *myTransformableSansClassName;
	 NSString *myTransformableWithClassName;
	 NSString *parentName;
} ParentMOAttributes;

extern const struct ParentMORelationships {
	 NSString *children;
} ParentMORelationships;

extern const struct ParentMOFetchedProperties {
} ParentMOFetchedProperties;

@class ChildMO;












@class NSObject;
@class NSColor;


@interface ParentMOID : NSManagedObjectID {}
@end

@interface _ParentMO : HumanMO {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ParentMOID*)objectID;




@property (nonatomic, retain) NSData *myBinaryData;


//- (BOOL)validateMyBinaryData:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *myBoolean;


@property BOOL myBooleanValue;
- (BOOL)myBooleanValue;
- (void)setMyBooleanValue:(BOOL)value_;

//- (BOOL)validateMyBoolean:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSDate *myDate;


//- (BOOL)validateMyDate:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSDecimalNumber *myDecimal;


//- (BOOL)validateMyDecimal:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *myDouble;


@property double myDoubleValue;
- (double)myDoubleValue;
- (void)setMyDoubleValue:(double)value_;

//- (BOOL)validateMyDouble:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *myFloat;


@property float myFloatValue;
- (float)myFloatValue;
- (void)setMyFloatValue:(float)value_;

//- (BOOL)validateMyFloat:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *myInt16;


@property int16_t myInt16Value;
- (int16_t)myInt16Value;
- (void)setMyInt16Value:(int16_t)value_;

//- (BOOL)validateMyInt16:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *myInt16Transient;


@property int16_t myInt16TransientValue;
- (int16_t)myInt16TransientValue;
- (void)setMyInt16TransientValue:(int16_t)value_;

//- (BOOL)validateMyInt16Transient:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *myInt32;


@property int32_t myInt32Value;
- (int32_t)myInt32Value;
- (void)setMyInt32Value:(int32_t)value_;

//- (BOOL)validateMyInt32:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *myInt64;


@property int64_t myInt64Value;
- (int64_t)myInt64Value;
- (void)setMyInt64Value:(int64_t)value_;

//- (BOOL)validateMyInt64:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *myString;


//- (BOOL)validateMyString:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) idmyTransformableSansClassName;


//- (BOOL)validateMyTransformableSansClassName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSColor *myTransformableWithClassName;


//- (BOOL)validateMyTransformableWithClassName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *parentName;


//- (BOOL)validateParentName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSSet* children;

- (NSMutableSet*)childrenSet;




@end

@interface _ParentMO (CoreDataGeneratedAccessors)

- (void)addChildren:(NSSet*)value_;
- (void)removeChildren:(NSSet*)value_;
- (void)addChildrenObject:(ChildMO*)value_;
- (void)removeChildrenObject:(ChildMO*)value_;

@end

@interface _ParentMO (CoreDataGeneratedPrimitiveAccessors)


- (NSData *)primitiveMyBinaryData;
- (void)setPrimitiveMyBinaryData:(NSData *)value;




- (NSNumber *)primitiveMyBoolean;
- (void)setPrimitiveMyBoolean:(NSNumber *)value;

- (BOOL)primitiveMyBooleanValue;
- (void)setPrimitiveMyBooleanValue:(BOOL)value_;




- (NSDate *)primitiveMyDate;
- (void)setPrimitiveMyDate:(NSDate *)value;




- (NSDecimalNumber *)primitiveMyDecimal;
- (void)setPrimitiveMyDecimal:(NSDecimalNumber *)value;




- (NSNumber *)primitiveMyDouble;
- (void)setPrimitiveMyDouble:(NSNumber *)value;

- (double)primitiveMyDoubleValue;
- (void)setPrimitiveMyDoubleValue:(double)value_;




- (NSNumber *)primitiveMyFloat;
- (void)setPrimitiveMyFloat:(NSNumber *)value;

- (float)primitiveMyFloatValue;
- (void)setPrimitiveMyFloatValue:(float)value_;




- (NSNumber *)primitiveMyInt16;
- (void)setPrimitiveMyInt16:(NSNumber *)value;

- (int16_t)primitiveMyInt16Value;
- (void)setPrimitiveMyInt16Value:(int16_t)value_;




- (NSNumber *)primitiveMyInt16Transient;
- (void)setPrimitiveMyInt16Transient:(NSNumber *)value;

- (int16_t)primitiveMyInt16TransientValue;
- (void)setPrimitiveMyInt16TransientValue:(int16_t)value_;




- (NSNumber *)primitiveMyInt32;
- (void)setPrimitiveMyInt32:(NSNumber *)value;

- (int32_t)primitiveMyInt32Value;
- (void)setPrimitiveMyInt32Value:(int32_t)value_;




- (NSNumber *)primitiveMyInt64;
- (void)setPrimitiveMyInt64:(NSNumber *)value;

- (int64_t)primitiveMyInt64Value;
- (void)setPrimitiveMyInt64Value:(int64_t)value_;




- (NSString *)primitiveMyString;
- (void)setPrimitiveMyString:(NSString *)value;




- (id)primitiveMyTransformableSansClassName;
- (void)setPrimitiveMyTransformableSansClassName:(id)value;




- (NSColor *)primitiveMyTransformableWithClassName;
- (void)setPrimitiveMyTransformableWithClassName:(NSColor *)value;




- (NSString *)primitiveParentName;
- (void)setPrimitiveParentName:(NSString *)value;





- (NSMutableSet*)primitiveChildren;
- (void)setPrimitiveChildren:(NSMutableSet*)value;


@end
