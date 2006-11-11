// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ParentMO.h instead.

#import <CoreData/CoreData.h>
#import "HumanMO.h"


@class ChildMO;


@interface _ParentMO : HumanMO {}


- (NSNumber*)myInt16Transient;
- (void)setMyInt16Transient:(NSNumber*)value_;

- (short)myInt16TransientValue;
- (void)setMyInt16TransientValue:(short)value_;

//- (BOOL)validateMyInt16Transient:(id*)value_ error:(NSError**)error_;



- (NSString*)parentName;
- (void)setParentName:(NSString*)value_;

//- (BOOL)validateParentName:(id*)value_ error:(NSError**)error_;



- (NSDecimalNumber*)myDecimal;
- (void)setMyDecimal:(NSDecimalNumber*)value_;

//- (BOOL)validateMyDecimal:(id*)value_ error:(NSError**)error_;



- (NSDate*)myDate;
- (void)setMyDate:(NSDate*)value_;

//- (BOOL)validateMyDate:(id*)value_ error:(NSError**)error_;



- (NSNumber*)myBoolean;
- (void)setMyBoolean:(NSNumber*)value_;

- (BOOL)myBooleanValue;
- (void)setMyBooleanValue:(BOOL)value_;

//- (BOOL)validateMyBoolean:(id*)value_ error:(NSError**)error_;



- (NSNumber*)myInt64;
- (void)setMyInt64:(NSNumber*)value_;

- (long long)myInt64Value;
- (void)setMyInt64Value:(long long)value_;

//- (BOOL)validateMyInt64:(id*)value_ error:(NSError**)error_;



- (NSNumber*)myDouble;
- (void)setMyDouble:(NSNumber*)value_;

- (double)myDoubleValue;
- (void)setMyDoubleValue:(double)value_;

//- (BOOL)validateMyDouble:(id*)value_ error:(NSError**)error_;



- (NSNumber*)myInt16;
- (void)setMyInt16:(NSNumber*)value_;

- (short)myInt16Value;
- (void)setMyInt16Value:(short)value_;

//- (BOOL)validateMyInt16:(id*)value_ error:(NSError**)error_;



- (NSNumber*)myFloat;
- (void)setMyFloat:(NSNumber*)value_;

- (float)myFloatValue;
- (void)setMyFloatValue:(float)value_;

//- (BOOL)validateMyFloat:(id*)value_ error:(NSError**)error_;



- (NSData*)myBinaryData;
- (void)setMyBinaryData:(NSData*)value_;

//- (BOOL)validateMyBinaryData:(id*)value_ error:(NSError**)error_;



- (NSString*)myString;
- (void)setMyString:(NSString*)value_;

//- (BOOL)validateMyString:(id*)value_ error:(NSError**)error_;



- (NSNumber*)myInt32;
- (void)setMyInt32:(NSNumber*)value_;

- (long)myInt32Value;
- (void)setMyInt32Value:(long)value_;

//- (BOOL)validateMyInt32:(id*)value_ error:(NSError**)error_;




- (void)addChildrenObject:(ChildMO*)value_;
- (void)removeChildrenObject:(ChildMO*)value_;
- (NSMutableSet*)childrenSet;


@end
