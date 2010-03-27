// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChildMO.m instead.

#import "_ChildMO.h"

@implementation ChildMOID
@end

@implementation _ChildMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Child" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Child";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName: @"Child" inManagedObjectContext: moc_];
}

- (ChildMOID*)objectID {
	return (ChildMOID*)[super objectID];
}




@dynamic childName;






@dynamic parent;

	




+ (NSArray*)fetchByParent:(NSManagedObjectContext*)moc_ parent:(ParentMO*)parent_ {
	NSError *error = nil;
	NSArray *result = [self fetchByParent:moc_ parent:parent_ error:&error];
	if (error) {
#if TARGET_OS_IPHONE
		NSLog(@"error: %@", error);
#else
		[NSApp presentError:error];
#endif
	}
	return result;
}
+ (NSArray*)fetchByParent:(NSManagedObjectContext*)moc_ parent:(ParentMO*)parent_ error:(NSError**)error_ {
	NSError *error = nil;
	
	NSManagedObjectModel *model = [[moc_ persistentStoreCoordinator] managedObjectModel];
	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"byParent"
													 substitutionVariables:[NSDictionary dictionaryWithObjectsAndKeys:
														
														parent_, @"parent",
														
														nil]
													 ];
	NSAssert(fetchRequest, @"Can't find fetch request named \"byParent\".");
	
	NSArray *result = [moc_ executeFetchRequest:fetchRequest error:&error];
	if (error_) *error_ = error;
	return result;
}


@end
