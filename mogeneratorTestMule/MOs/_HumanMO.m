// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HumanMO.m instead.

#import "_HumanMO.h"

@implementation HumanMOID
@end

@implementation _HumanMO

+ (id)newInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	return [NSEntityDescription insertNewObjectForEntityForName:@"Human" inManagedObjectContext:moc_];									 
}

- (HumanMOID*)objectID {
	return (HumanMOID*)[super objectID];
}






- (NSString*)humanName {
	[self willAccessValueForKey:@"humanName"];
	NSString *result = [self primitiveValueForKey:@"humanName"];
	[self didAccessValueForKey:@"humanName"];
	return result;
}

- (void)setHumanName:(NSString*)value_ {
	[self willChangeValueForKey:@"humanName"];
	[self setPrimitiveValue:value_ forKey:@"humanName"];
	[self didChangeValueForKey:@"humanName"];
}






- (NSData*)hairColorStorage {
	[self willAccessValueForKey:@"hairColorStorage"];
	NSData *result = [self primitiveValueForKey:@"hairColorStorage"];
	[self didAccessValueForKey:@"hairColorStorage"];
	return result;
}

- (void)setHairColorStorage:(NSData*)value_ {
	[self willChangeValueForKey:@"hairColorStorage"];
	[self setPrimitiveValue:value_ forKey:@"hairColorStorage"];
	[self didChangeValueForKey:@"hairColorStorage"];
}






	

- (NSManagedObject*)meaninglessRelationship {
	[self willAccessValueForKey:@"meaninglessRelationship"];
	NSManagedObject *result = [self primitiveValueForKey:@"meaninglessRelationship"];
	[self didAccessValueForKey:@"meaninglessRelationship"];
	return result;
}

- (void)setMeaninglessRelationship:(NSManagedObject*)value_ {
	[self willChangeValueForKey:@"meaninglessRelationship"];
	[self setPrimitiveValue:value_ forKey:@"meaninglessRelationship"];
	[self didChangeValueForKey:@"meaninglessRelationship"];
}

	




+ (id)fetchByHumanName:(NSManagedObjectContext*)moc_ humanName:(NSString*)humanName_ {
	NSError *error = nil;
	id result = [self fetchByHumanName:moc_ humanName:humanName_ error:&error];
	if (error) {
		[NSApp presentError:error];
	}
	return result;
}
+ (id)fetchByHumanName:(NSManagedObjectContext*)moc_ humanName:(NSString*)humanName_ error:(NSError**)error_ {
	NSError *error = nil;
	
	NSManagedObjectModel *model = [[moc_ persistentStoreCoordinator] managedObjectModel];
	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"byHumanName"
													 substitutionVariables:[NSDictionary dictionaryWithObjectsAndKeys:
														
														humanName_, @"humanName",
														
														nil]
													 ];
	NSAssert(fetchRequest, @"Can't find fetch request named \"byHumanName\".");
	
	id result = nil;
	NSArray *results = [moc_ executeFetchRequest:fetchRequest error:&error];
	
	if (!error) {
		switch ([results count]) {
			case 0:
				//	Nothing found matching the fetch request. That's cool, though: we'll just return nil.
				break;
			case 1:
				result = [results objectAtIndex:0];
				break;
			default:
				NSAssert1(NO, @"byHumanName: 0 or 1 objects expected, %u found", [results count]);
		}
	}
	
	if (error_) *error_ = error;
	return result;
}



+ (id)fetchOneByHumanName:(NSManagedObjectContext*)moc_ humanName:(NSString*)humanName_ {
	NSError *error = nil;
	id result = [self fetchOneByHumanName:moc_ humanName:humanName_ error:&error];
	if (error) {
		[NSApp presentError:error];
	}
	return result;
}
+ (id)fetchOneByHumanName:(NSManagedObjectContext*)moc_ humanName:(NSString*)humanName_ error:(NSError**)error_ {
	NSError *error = nil;
	
	NSManagedObjectModel *model = [[moc_ persistentStoreCoordinator] managedObjectModel];
	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"oneByHumanName"
													 substitutionVariables:[NSDictionary dictionaryWithObjectsAndKeys:
														
														humanName_, @"humanName",
														
														nil]
													 ];
	NSAssert(fetchRequest, @"Can't find fetch request named \"oneByHumanName\".");
	
	id result = nil;
	NSArray *results = [moc_ executeFetchRequest:fetchRequest error:&error];
	
	if (!error) {
		switch ([results count]) {
			case 0:
				//	Nothing found matching the fetch request. That's cool, though: we'll just return nil.
				break;
			case 1:
				result = [results objectAtIndex:0];
				break;
			default:
				NSAssert1(NO, @"oneByHumanName: 0 or 1 objects expected, %u found", [results count]);
		}
	}
	
	if (error_) *error_ = error;
	return result;
}


@end
