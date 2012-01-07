// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ParentMO.m instead.

#import "_ParentMO.h"

const struct ParentMOAttributes ParentMOAttributes = {
	.myBinaryData = @"myBinaryData",
	.myBoolean = @"myBoolean",
	.myDate = @"myDate",
	.myDecimal = @"myDecimal",
	.myDouble = @"myDouble",
	.myFloat = @"myFloat",
	.myInt16 = @"myInt16",
	.myInt16Transient = @"myInt16Transient",
	.myInt32 = @"myInt32",
	.myInt64 = @"myInt64",
	.myString = @"myString",
	.myTransformableSansClassName = @"myTransformableSansClassName",
	.myTransformableWithClassName = @"myTransformableWithClassName",
	.parentName = @"parentName",
};

const struct ParentMORelationships ParentMORelationships = {
	.children = @"children",
};

const struct ParentMOFetchedProperties ParentMOFetchedProperties = {
};

@implementation ParentMOID
@end

@implementation _ParentMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Parent" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Parent";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Parent" inManagedObjectContext:moc_];
}

- (ParentMOID*)objectID {
	return (ParentMOID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"myBooleanValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"myBoolean"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"myDoubleValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"myDouble"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"myFloatValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"myFloat"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"myInt16Value"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"myInt16"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"myInt16TransientValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"myInt16Transient"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"myInt32Value"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"myInt32"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"myInt64Value"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"myInt64"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic myBinaryData;






@dynamic myBoolean;



- (BOOL)myBooleanValue {
	NSNumber *result = [self myBoolean];
	return [result boolValue];
}

- (void)setMyBooleanValue:(BOOL)value_ {
	[self setMyBoolean:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveMyBooleanValue {
	NSNumber *result = [self primitiveMyBoolean];
	return [result boolValue];
}

- (void)setPrimitiveMyBooleanValue:(BOOL)value_ {
	[self setPrimitiveMyBoolean:[NSNumber numberWithBool:value_]];
}





@dynamic myDate;






@dynamic myDecimal;






@dynamic myDouble;



- (double)myDoubleValue {
	NSNumber *result = [self myDouble];
	return [result doubleValue];
}

- (void)setMyDoubleValue:(double)value_ {
	[self setMyDouble:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveMyDoubleValue {
	NSNumber *result = [self primitiveMyDouble];
	return [result doubleValue];
}

- (void)setPrimitiveMyDoubleValue:(double)value_ {
	[self setPrimitiveMyDouble:[NSNumber numberWithDouble:value_]];
}





@dynamic myFloat;



- (float)myFloatValue {
	NSNumber *result = [self myFloat];
	return [result floatValue];
}

- (void)setMyFloatValue:(float)value_ {
	[self setMyFloat:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveMyFloatValue {
	NSNumber *result = [self primitiveMyFloat];
	return [result floatValue];
}

- (void)setPrimitiveMyFloatValue:(float)value_ {
	[self setPrimitiveMyFloat:[NSNumber numberWithFloat:value_]];
}





@dynamic myInt16;



- (int16_t)myInt16Value {
	NSNumber *result = [self myInt16];
	return [result shortValue];
}

- (void)setMyInt16Value:(int16_t)value_ {
	[self setMyInt16:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveMyInt16Value {
	NSNumber *result = [self primitiveMyInt16];
	return [result shortValue];
}

- (void)setPrimitiveMyInt16Value:(int16_t)value_ {
	[self setPrimitiveMyInt16:[NSNumber numberWithShort:value_]];
}





@dynamic myInt16Transient;



- (int16_t)myInt16TransientValue {
	NSNumber *result = [self myInt16Transient];
	return [result shortValue];
}

- (void)setMyInt16TransientValue:(int16_t)value_ {
	[self setMyInt16Transient:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveMyInt16TransientValue {
	NSNumber *result = [self primitiveMyInt16Transient];
	return [result shortValue];
}

- (void)setPrimitiveMyInt16TransientValue:(int16_t)value_ {
	[self setPrimitiveMyInt16Transient:[NSNumber numberWithShort:value_]];
}





@dynamic myInt32;



- (int32_t)myInt32Value {
	NSNumber *result = [self myInt32];
	return [result intValue];
}

- (void)setMyInt32Value:(int32_t)value_ {
	[self setMyInt32:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveMyInt32Value {
	NSNumber *result = [self primitiveMyInt32];
	return [result intValue];
}

- (void)setPrimitiveMyInt32Value:(int32_t)value_ {
	[self setPrimitiveMyInt32:[NSNumber numberWithInt:value_]];
}





@dynamic myInt64;



- (int64_t)myInt64Value {
	NSNumber *result = [self myInt64];
	return [result longLongValue];
}

- (void)setMyInt64Value:(int64_t)value_ {
	[self setMyInt64:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveMyInt64Value {
	NSNumber *result = [self primitiveMyInt64];
	return [result longLongValue];
}

- (void)setPrimitiveMyInt64Value:(int64_t)value_ {
	[self setPrimitiveMyInt64:[NSNumber numberWithLongLong:value_]];
}





@dynamic myString;






@dynamic myTransformableSansClassName;






@dynamic myTransformableWithClassName;






@dynamic parentName;






@dynamic children;

	
- (NSMutableSet*)childrenSet {
	[self willAccessValueForKey:@"children"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"children"];
  
	[self didAccessValueForKey:@"children"];
	return result;
}
	





@end
