// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ParentMO.m instead.

#import "_ParentMO.h"

@implementation ParentMOID
@end

@implementation _ParentMO

+ (id)newInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	return [NSEntityDescription insertNewObjectForEntityForName:@"Parent" inManagedObjectContext:moc_];									 
}

- (ParentMOID*)objectID {
	return (ParentMOID*)[super objectID];
}




- (NSNumber*)myDouble {
	[self willAccessValueForKey:@"myDouble"];
	NSNumber *result = [self primitiveValueForKey:@"myDouble"];
	[self didAccessValueForKey:@"myDouble"];
	return result;
}

- (void)setMyDouble:(NSNumber*)value_ {
	[self willChangeValueForKey:@"myDouble"];
	[self setPrimitiveValue:value_ forKey:@"myDouble"];
	[self didChangeValueForKey:@"myDouble"];
}



- (double)myDoubleValue {
	NSNumber *result = [self myDouble];
	return result ? [result doubleValue] : 0;
}

- (void)setMyDoubleValue:(double)value_ {
	[self setMyDouble:[NSNumber numberWithDouble:value_]];
}






- (NSString*)myString {
	[self willAccessValueForKey:@"myString"];
	NSString *result = [self primitiveValueForKey:@"myString"];
	[self didAccessValueForKey:@"myString"];
	return result;
}

- (void)setMyString:(NSString*)value_ {
	[self willChangeValueForKey:@"myString"];
	[self setPrimitiveValue:value_ forKey:@"myString"];
	[self didChangeValueForKey:@"myString"];
}






- (NSDecimalNumber*)myDecimal {
	[self willAccessValueForKey:@"myDecimal"];
	NSDecimalNumber *result = [self primitiveValueForKey:@"myDecimal"];
	[self didAccessValueForKey:@"myDecimal"];
	return result;
}

- (void)setMyDecimal:(NSDecimalNumber*)value_ {
	[self willChangeValueForKey:@"myDecimal"];
	[self setPrimitiveValue:value_ forKey:@"myDecimal"];
	[self didChangeValueForKey:@"myDecimal"];
}






- (NSString*)parentName {
	[self willAccessValueForKey:@"parentName"];
	NSString *result = [self primitiveValueForKey:@"parentName"];
	[self didAccessValueForKey:@"parentName"];
	return result;
}

- (void)setParentName:(NSString*)value_ {
	[self willChangeValueForKey:@"parentName"];
	[self setPrimitiveValue:value_ forKey:@"parentName"];
	[self didChangeValueForKey:@"parentName"];
}






- (NSDate*)myDate {
	[self willAccessValueForKey:@"myDate"];
	NSDate *result = [self primitiveValueForKey:@"myDate"];
	[self didAccessValueForKey:@"myDate"];
	return result;
}

- (void)setMyDate:(NSDate*)value_ {
	[self willChangeValueForKey:@"myDate"];
	[self setPrimitiveValue:value_ forKey:@"myDate"];
	[self didChangeValueForKey:@"myDate"];
}






- (NSNumber*)myFloat {
	[self willAccessValueForKey:@"myFloat"];
	NSNumber *result = [self primitiveValueForKey:@"myFloat"];
	[self didAccessValueForKey:@"myFloat"];
	return result;
}

- (void)setMyFloat:(NSNumber*)value_ {
	[self willChangeValueForKey:@"myFloat"];
	[self setPrimitiveValue:value_ forKey:@"myFloat"];
	[self didChangeValueForKey:@"myFloat"];
}



- (float)myFloatValue {
	NSNumber *result = [self myFloat];
	return result ? [result floatValue] : 0;
}

- (void)setMyFloatValue:(float)value_ {
	[self setMyFloat:[NSNumber numberWithFloat:value_]];
}






- (NSNumber*)myInt32 {
	[self willAccessValueForKey:@"myInt32"];
	NSNumber *result = [self primitiveValueForKey:@"myInt32"];
	[self didAccessValueForKey:@"myInt32"];
	return result;
}

- (void)setMyInt32:(NSNumber*)value_ {
	[self willChangeValueForKey:@"myInt32"];
	[self setPrimitiveValue:value_ forKey:@"myInt32"];
	[self didChangeValueForKey:@"myInt32"];
}



- (int)myInt32Value {
	NSNumber *result = [self myInt32];
	return result ? [result intValue] : 0;
}

- (void)setMyInt32Value:(int)value_ {
	[self setMyInt32:[NSNumber numberWithInt:value_]];
}






- (NSColor*)myTransformableWithClassName {
	[self willAccessValueForKey:@"myTransformableWithClassName"];
	NSColor *result = [self primitiveValueForKey:@"myTransformableWithClassName"];
	[self didAccessValueForKey:@"myTransformableWithClassName"];
	return result;
}

- (void)setMyTransformableWithClassName:(NSColor*)value_ {
	[self willChangeValueForKey:@"myTransformableWithClassName"];
	[self setPrimitiveValue:value_ forKey:@"myTransformableWithClassName"];
	[self didChangeValueForKey:@"myTransformableWithClassName"];
}






- (NSData*)myBinaryData {
	[self willAccessValueForKey:@"myBinaryData"];
	NSData *result = [self primitiveValueForKey:@"myBinaryData"];
	[self didAccessValueForKey:@"myBinaryData"];
	return result;
}

- (void)setMyBinaryData:(NSData*)value_ {
	[self willChangeValueForKey:@"myBinaryData"];
	[self setPrimitiveValue:value_ forKey:@"myBinaryData"];
	[self didChangeValueForKey:@"myBinaryData"];
}






- (NSNumber*)myInt16Transient {
	[self willAccessValueForKey:@"myInt16Transient"];
	NSNumber *result = [self primitiveValueForKey:@"myInt16Transient"];
	[self didAccessValueForKey:@"myInt16Transient"];
	return result;
}

- (void)setMyInt16Transient:(NSNumber*)value_ {
	[self willChangeValueForKey:@"myInt16Transient"];
	[self setPrimitiveValue:value_ forKey:@"myInt16Transient"];
	[self didChangeValueForKey:@"myInt16Transient"];
}



- (short)myInt16TransientValue {
	NSNumber *result = [self myInt16Transient];
	return result ? [result shortValue] : 0;
}

- (void)setMyInt16TransientValue:(short)value_ {
	[self setMyInt16Transient:[NSNumber numberWithShort:value_]];
}






- (NSNumber*)myBoolean {
	[self willAccessValueForKey:@"myBoolean"];
	NSNumber *result = [self primitiveValueForKey:@"myBoolean"];
	[self didAccessValueForKey:@"myBoolean"];
	return result;
}

- (void)setMyBoolean:(NSNumber*)value_ {
	[self willChangeValueForKey:@"myBoolean"];
	[self setPrimitiveValue:value_ forKey:@"myBoolean"];
	[self didChangeValueForKey:@"myBoolean"];
}



- (BOOL)myBooleanValue {
	NSNumber *result = [self myBoolean];
	return result ? [result boolValue] : 0;
}

- (void)setMyBooleanValue:(BOOL)value_ {
	[self setMyBoolean:[NSNumber numberWithBool:value_]];
}






- (NSNumber*)myInt64 {
	[self willAccessValueForKey:@"myInt64"];
	NSNumber *result = [self primitiveValueForKey:@"myInt64"];
	[self didAccessValueForKey:@"myInt64"];
	return result;
}

- (void)setMyInt64:(NSNumber*)value_ {
	[self willChangeValueForKey:@"myInt64"];
	[self setPrimitiveValue:value_ forKey:@"myInt64"];
	[self didChangeValueForKey:@"myInt64"];
}



- (long long)myInt64Value {
	NSNumber *result = [self myInt64];
	return result ? [result longLongValue] : 0;
}

- (void)setMyInt64Value:(long long)value_ {
	[self setMyInt64:[NSNumber numberWithLongLong:value_]];
}






- (NSNumber*)myInt16 {
	[self willAccessValueForKey:@"myInt16"];
	NSNumber *result = [self primitiveValueForKey:@"myInt16"];
	[self didAccessValueForKey:@"myInt16"];
	return result;
}

- (void)setMyInt16:(NSNumber*)value_ {
	[self willChangeValueForKey:@"myInt16"];
	[self setPrimitiveValue:value_ forKey:@"myInt16"];
	[self didChangeValueForKey:@"myInt16"];
}



- (short)myInt16Value {
	NSNumber *result = [self myInt16];
	return result ? [result shortValue] : 0;
}

- (void)setMyInt16Value:(short)value_ {
	[self setMyInt16:[NSNumber numberWithShort:value_]];
}






- (NSObject*)myTransformableSansClassName {
	[self willAccessValueForKey:@"myTransformableSansClassName"];
	NSObject *result = [self primitiveValueForKey:@"myTransformableSansClassName"];
	[self didAccessValueForKey:@"myTransformableSansClassName"];
	return result;
}

- (void)setMyTransformableSansClassName:(NSObject*)value_ {
	[self willChangeValueForKey:@"myTransformableSansClassName"];
	[self setPrimitiveValue:value_ forKey:@"myTransformableSansClassName"];
	[self didChangeValueForKey:@"myTransformableSansClassName"];
}






	

- (NSSet*)children {
	[self willAccessValueForKey:@"children"];
	NSSet *result = [self primitiveValueForKey:@"children"];
	[self didAccessValueForKey:@"children"];
	return result;
}

- (void)setChildren:(NSSet*)value_ {
	[self willChangeValueForKey:@"children" withSetMutation:NSKeyValueSetSetMutation usingObjects:value_];
	[[self primitiveValueForKey:@"children"] setSet:value_];
	[self didChangeValueForKey:@"children" withSetMutation:NSKeyValueSetSetMutation usingObjects:value_];
}

- (void)addChildren:(NSSet*)value_ {
	[self willChangeValueForKey:@"children" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value_];
	[[self primitiveValueForKey:@"children"] unionSet:value_];
	[self didChangeValueForKey:@"children" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value_];
}

-(void)removeChildren:(NSSet*)value_ {
	[self willChangeValueForKey:@"children" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value_];
	[[self primitiveValueForKey:@"children"] minusSet:value_];
	[self didChangeValueForKey:@"children" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value_];
}
	
- (void)addChildrenObject:(ChildMO*)value_ {
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value_ count:1];
	[self willChangeValueForKey:@"children" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
	[[self primitiveValueForKey:@"children"] addObject:value_];
	[self didChangeValueForKey:@"children" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
	[changedObjects release];
}

- (void)removeChildrenObject:(ChildMO*)value_ {
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value_ count:1];
	[self willChangeValueForKey:@"children" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	[[self primitiveValueForKey:@"children"] removeObject:value_];
	[self didChangeValueForKey:@"children" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	[changedObjects release];
}

- (NSMutableSet*)childrenSet {
	[self willAccessValueForKey:@"children"];
	NSMutableSet *result = [self mutableSetValueForKey:@"children"];
	[self didAccessValueForKey:@"children"];
	return result;
}
	



@end
