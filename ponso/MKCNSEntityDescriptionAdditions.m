/*
 Copyright 2011 Marko Karppinen & Co. LLC.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 MKCNSEntityDescriptionAdditions.m
 Created by Nikita Zhuk on 22.1.2011.
 */


#import "MKCNSEntityDescriptionAdditions.h"
#import "MKCNSManagedObjectModelAdditions.h"

@interface MKCNSRelationshipDescriptionIDKeyPathDependencyFilter : NSObject <MKCNSRelationshipDescriptionDependencyFilter> @end

@implementation MKCNSRelationshipDescriptionIDKeyPathDependencyFilter

- (BOOL)includeRelationship:(NSRelationshipDescription *)relationship
{
	if([[relationship entity] isEqual:[relationship destinationEntity]])
	{
		// Relationship from entity to itself - ignore.
		return NO;
	}
	
	return [[[relationship userInfo] objectForKey:@"destinationEntityIDKeyPath"] length] > 0;
}

@end

@interface MKCNSRelationshipDescriptionNonTransientDependencyFilter : NSObject <MKCNSRelationshipDescriptionDependencyFilter> @end
@implementation MKCNSRelationshipDescriptionNonTransientDependencyFilter

- (BOOL)includeRelationship:(NSRelationshipDescription *)relationship
{
	if([[relationship entity] isEqual:[relationship destinationEntity]])
		return NO;
    
    if([relationship isTransient])
        return NO;
    
    return YES;
}

@end

@implementation NSEntityDescription(MKCNSEntityDescriptionAdditions)

/** @TypeInfo NSAttributeDescription */
- (NSArray*)noninheritedRelationshipsInIDKeyPathTopologicalOrder
{
	NSArray *relationships = nil;
	
	NSEntityDescription *superentity = [self superentity];
	if (superentity != nil)
	{
		NSMutableArray *result = [[[[self relationshipsByName] allValues] mutableCopy] autorelease];
		[result removeObjectsInArray:[[superentity relationshipsByName] allValues]];
		relationships = result;
	}
	else
	{
		relationships = [[self relationshipsByName] allValues];
	}
	
	// Initially, sort relationships in alphabetical order.
	relationships = [relationships sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
	
	// Sort relationships in topological order by their destination entities including "IDKeyPath" relationships in dependencies.
	// Although this is a bit naive O(n^2) sort, it should be fast enough since n (=number of relationships) is usually very low.
	id IDKeyPathDependencyFilter = [[[MKCNSRelationshipDescriptionIDKeyPathDependencyFilter alloc] init] autorelease];
	NSArray *allEntities = [[self managedObjectModel] entitiesInTopologicalOrderUsingDependencyFilter:IDKeyPathDependencyFilter];
	NSMutableArray *sortedRelationships = [NSMutableArray arrayWithCapacity:[relationships count]];
	
	for (NSEntityDescription *entity in allEntities)
	{
		for (NSRelationshipDescription *relationship in relationships)
		{
			if([[relationship destinationEntity] isEqual:entity])
			{
				[sortedRelationships addObject:relationship];
			}
		}
	}
	
	return sortedRelationships;
}

- (void)checkNonTransientRelationshipCycles
{
    id dependencyFilter = [[[MKCNSRelationshipDescriptionNonTransientDependencyFilter alloc] init] autorelease];
    NSArray *entities = [[self managedObjectModel] entitiesInTopologicalOrderUsingDependencyFilter:dependencyFilter];
    
    if(entities == nil)
    {
        NSString *desc = @"Cycles were found in non-transient relationships.";
        
        [[NSException exceptionWithName:@"StrongRelationshipCyclesFoundException" reason:desc userInfo:nil] raise];
    }
}

@end
