// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ParentMO.h instead.

#import <CoreData/CoreData.h>
#import "HumanMO.h"

@class ChildMO;

@interface ParentMOID : NSManagedObjectID {}
@end

@interface _ParentMO : HumanMO {}
+ (id)newInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ParentMOID*)objectID;



- (NSNumber*)myDouble;
- (void)setMyDouble:(NSNumber*)value_;
#if defined(MAC_OS_X_VERSION_10_5) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
@property (retain) NSNumber *myDouble;
#endif

- (double)myDoubleValue;
- (void)setMyDoubleValue:(double)value_;

//- (BOOL)validateMyDouble:(id*)value_ error:(NSError**)error_;



- (NSString*)myString;
- (void)setMyString:(NSString*)value_;
#if defined(MAC_OS_X_VERSION_10_5) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
@property (retain) NSString *myString;
#endif

//- (BOOL)validateMyString:(id*)value_ error:(NSError**)error_;



- (NSDecimalNumber*)myDecimal;
- (void)setMyDecimal:(NSDecimalNumber*)value_;
#if defined(MAC_OS_X_VERSION_10_5) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
@property (retain) NSDecimalNumber *myDecimal;
#endif

//- (BOOL)validateMyDecimal:(id*)value_ error:(NSError**)error_;



- (NSString*)parentName;
- (void)setParentName:(NSString*)value_;
#if defined(MAC_OS_X_VERSION_10_5) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
@property (retain) NSString *parentName;
#endif

//- (BOOL)validateParentName:(id*)value_ error:(NSError**)error_;



- (NSDate*)myDate;
- (void)setMyDate:(NSDate*)value_;
#if defined(MAC_OS_X_VERSION_10_5) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
@property (retain) NSDate *myDate;
#endif

//- (BOOL)validateMyDate:(id*)value_ error:(NSError**)error_;



- (NSNumber*)myFloat;
- (void)setMyFloat:(NSNumber*)value_;
#if defined(MAC_OS_X_VERSION_10_5) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
@property (retain) NSNumber *myFloat;
#endif

- (float)myFloatValue;
- (void)setMyFloatValue:(float)value_;

//- (BOOL)validateMyFloat:(id*)value_ error:(NSError**)error_;



- (NSNumber*)myInt32;
- (void)setMyInt32:(NSNumber*)value_;
#if defined(MAC_OS_X_VERSION_10_5) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
@property (retain) NSNumber *myInt32;
#endif

- (int)myInt32Value;
- (void)setMyInt32Value:(int)value_;

//- (BOOL)validateMyInt32:(id*)value_ error:(NSError**)error_;



- (NSData*)myBinaryData;
- (void)setMyBinaryData:(NSData*)value_;
#if defined(MAC_OS_X_VERSION_10_5) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
@property (retain) NSData *myBinaryData;
#endif

//- (BOOL)validateMyBinaryData:(id*)value_ error:(NSError**)error_;



- (NSNumber*)myInt16Transient;
- (void)setMyInt16Transient:(NSNumber*)value_;
#if defined(MAC_OS_X_VERSION_10_5) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
@property (retain) NSNumber *myInt16Transient;
#endif

- (short)myInt16TransientValue;
- (void)setMyInt16TransientValue:(short)value_;

//- (BOOL)validateMyInt16Transient:(id*)value_ error:(NSError**)error_;



- (NSNumber*)myBoolean;
- (void)setMyBoolean:(NSNumber*)value_;
#if defined(MAC_OS_X_VERSION_10_5) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
@property (retain) NSNumber *myBoolean;
#endif

- (BOOL)myBooleanValue;
- (void)setMyBooleanValue:(BOOL)value_;

//- (BOOL)validateMyBoolean:(id*)value_ error:(NSError**)error_;



- (NSNumber*)myInt64;
- (void)setMyInt64:(NSNumber*)value_;
#if defined(MAC_OS_X_VERSION_10_5) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
@property (retain) NSNumber *myInt64;
#endif

- (long long)myInt64Value;
- (void)setMyInt64Value:(long long)value_;

//- (BOOL)validateMyInt64:(id*)value_ error:(NSError**)error_;



- (NSNumber*)myInt16;
- (void)setMyInt16:(NSNumber*)value_;
#if defined(MAC_OS_X_VERSION_10_5) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
@property (retain) NSNumber *myInt16;
#endif

- (short)myInt16Value;
- (void)setMyInt16Value:(short)value_;

//- (BOOL)validateMyInt16:(id*)value_ error:(NSError**)error_;




- (NSSet*)children;
- (void)addChildren:(NSSet*)value_;
- (void)removeChildren:(NSSet*)value_;
- (void)addChildrenObject:(ChildMO*)value_;
- (void)removeChildrenObject:(ChildMO*)value_;
- (NSMutableSet*)childrenSet;
#if defined(MAC_OS_X_VERSION_10_5) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
@property (retain) NSSet* children;
#endif



@end
