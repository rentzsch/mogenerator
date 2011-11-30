// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ParentMO.h instead.

#import <CoreData/CoreData.h>
#import "HumanMO.h"

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


@property short myInt16Value;
- (short)myInt16Value;
- (void)setMyInt16Value:(short)value_;

//- (BOOL)validateMyInt16:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *myInt16Transient;


@property short myInt16TransientValue;
- (short)myInt16TransientValue;
- (void)setMyInt16TransientValue:(short)value_;

//- (BOOL)validateMyInt16Transient:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *myInt32;


@property int myInt32Value;
- (int)myInt32Value;
- (void)setMyInt32Value:(int)value_;

//- (BOOL)validateMyInt32:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *myInt64;


@property long long myInt64Value;
- (long long)myInt64Value;
- (void)setMyInt64Value:(long long)value_;

//- (BOOL)validateMyInt64:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *myString;


//- (BOOL)validateMyString:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSObject *myTransformableSansClassName;


//- (BOOL)validateMyTransformableSansClassName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSColor *myTransformableWithClassName;


//- (BOOL)validateMyTransformableWithClassName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *parentName;


//- (BOOL)validateParentName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSOrderedSet* children;

- (NSMutableOrderedSet*)childrenSet;




@end

@interface _ParentMO (CoreDataGeneratedAccessors)

- (void)addChildren:(NSOrderedSet*)value_;
- (void)removeChildren:(NSOrderedSet*)value_;
- (void)addChildrenObject:(ChildMO*)value_;
- (void)removeChildrenObject:(ChildMO*)value_;

@end

@interface _ParentMO (CoreDataGeneratedPrimitiveAccessors)


- (NSData*)primitiveMyBinaryData;
- (void)setPrimitiveMyBinaryData:(NSData*)value;




- (NSNumber*)primitiveMyBoolean;
- (void)setPrimitiveMyBoolean:(NSNumber*)value;

- (BOOL)primitiveMyBooleanValue;
- (void)setPrimitiveMyBooleanValue:(BOOL)value_;




- (NSDate*)primitiveMyDate;
- (void)setPrimitiveMyDate:(NSDate*)value;




- (NSDecimalNumber*)primitiveMyDecimal;
- (void)setPrimitiveMyDecimal:(NSDecimalNumber*)value;




- (NSNumber*)primitiveMyDouble;
- (void)setPrimitiveMyDouble:(NSNumber*)value;

- (double)primitiveMyDoubleValue;
- (void)setPrimitiveMyDoubleValue:(double)value_;




- (NSNumber*)primitiveMyFloat;
- (void)setPrimitiveMyFloat:(NSNumber*)value;

- (float)primitiveMyFloatValue;
- (void)setPrimitiveMyFloatValue:(float)value_;




- (NSNumber*)primitiveMyInt16;
- (void)setPrimitiveMyInt16:(NSNumber*)value;

- (short)primitiveMyInt16Value;
- (void)setPrimitiveMyInt16Value:(short)value_;




- (NSNumber*)primitiveMyInt16Transient;
- (void)setPrimitiveMyInt16Transient:(NSNumber*)value;

- (short)primitiveMyInt16TransientValue;
- (void)setPrimitiveMyInt16TransientValue:(short)value_;




- (NSNumber*)primitiveMyInt32;
- (void)setPrimitiveMyInt32:(NSNumber*)value;

- (int)primitiveMyInt32Value;
- (void)setPrimitiveMyInt32Value:(int)value_;




- (NSNumber*)primitiveMyInt64;
- (void)setPrimitiveMyInt64:(NSNumber*)value;

- (long long)primitiveMyInt64Value;
- (void)setPrimitiveMyInt64Value:(long long)value_;




- (NSString*)primitiveMyString;
- (void)setPrimitiveMyString:(NSString*)value;




- (NSObject*)primitiveMyTransformableSansClassName;
- (void)setPrimitiveMyTransformableSansClassName:(NSObject*)value;




- (NSColor*)primitiveMyTransformableWithClassName;
- (void)setPrimitiveMyTransformableWithClassName:(NSColor*)value;




- (NSString*)primitiveParentName;
- (void)setPrimitiveParentName:(NSString*)value;





- (NSMutableOrderedSet*)primitiveChildren;
- (void)setPrimitiveChildren:(NSMutableOrderedSet*)value;


@end
