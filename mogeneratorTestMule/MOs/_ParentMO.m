// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ParentMO.m instead.

#import "_ParentMO.h"

@implementation ParentMOID
@end

@implementation _ParentMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Parent" inManagedObjectContext:moc_];
}

- (ParentMOID*)objectID {
	return (ParentMOID*)[super objectID];
}




@dynamic myInt16Transient;



- (short)myInt16TransientValue {
	NSNumber *result = [self myInt16Transient];
	return result ? [result shortValue] : 0;
}

- (void)setMyInt16TransientValue:(short)value_ {
	[self setMyInt16Transient:[NSNumber numberWithShort:value_]];
}






@dynamic parentName;






@dynamic myTransformableSansClassName;






@dynamic myDecimal;






@dynamic myDate;






@dynamic myTransformableWithClassName;






@dynamic myBoolean;



- (BOOL)myBooleanValue {
	NSNumber *result = [self myBoolean];
	return result ? [result boolValue] : 0;
}

- (void)setMyBooleanValue:(BOOL)value_ {
	[self setMyBoolean:[NSNumber numberWithBool:value_]];
}






@dynamic myInt64;



- (long long)myInt64Value {
	NSNumber *result = [self myInt64];
	return result ? [result longLongValue] : 0;
}

- (void)setMyInt64Value:(long long)value_ {
	[self setMyInt64:[NSNumber numberWithLongLong:value_]];
}






@dynamic myDouble;



- (double)myDoubleValue {
	NSNumber *result = [self myDouble];
	return result ? [result doubleValue] : 0;
}

- (void)setMyDoubleValue:(double)value_ {
	[self setMyDouble:[NSNumber numberWithDouble:value_]];
}






@dynamic myInt16;



- (short)myInt16Value {
	NSNumber *result = [self myInt16];
	return result ? [result shortValue] : 0;
}

- (void)setMyInt16Value:(short)value_ {
	[self setMyInt16:[NSNumber numberWithShort:value_]];
}






@dynamic myFloat;



- (float)myFloatValue {
	NSNumber *result = [self myFloat];
	return result ? [result floatValue] : 0;
}

- (void)setMyFloatValue:(float)value_ {
	[self setMyFloat:[NSNumber numberWithFloat:value_]];
}






@dynamic myBinaryData;






@dynamic myString;






@dynamic myInt32;



- (int)myInt32Value {
	NSNumber *result = [self myInt32];
	return result ? [result intValue] : 0;
}

- (void)setMyInt32Value:(int)value_ {
	[self setMyInt32:[NSNumber numberWithInt:value_]];
}






@dynamic children;

	

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
