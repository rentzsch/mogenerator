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
 
 MKCNSManagedObjectModelAdditions.m
 Created by Nikita Zhuk on 22.1.2011.
 */

#import "MKCNSManagedObjectModelAdditions.h"
#import "MKCDAGNode.h"

@interface MKCNSRelationshipDescriptionDefaultDependencyFilter : NSObject <MKCNSRelationshipDescriptionDependencyFilter> @end

@implementation MKCNSRelationshipDescriptionDefaultDependencyFilter

- (BOOL)includeRelationship:(NSRelationshipDescription *)relationship
{
	if([[relationship entity] isEqual:[relationship destinationEntity]])
	{
		// Relationship from entity to itself - ignore.
		return NO;
	}
	
	return ![relationship isTransient];
}

@end


@implementation NSManagedObjectModel(MKCNSManagedObjectModelAdditions)

- (NSArray *) entitiesInTopologicalOrderUsingDependencyFilter:(id<MKCNSRelationshipDescriptionDependencyFilter>) dependencyFilter
{
	// Wrap entitites in DAG nodes and place them all into dict for faster access
	NSMutableDictionary *entityNodes = [NSMutableDictionary dictionaryWithCapacity:[[self entities] count]];
	for (NSEntityDescription *entity in [self entities])
	{
		MKCDAGNode *node = [[[MKCDAGNode alloc] initWithObject:entity] autorelease];
		[entityNodes setObject:node forKey:[entity name]];
	}
	
	// Create DAG from entities based on their relationships
	MKCDAGNode *root = [[[MKCDAGNode alloc] initWithObject:nil] autorelease];
	
	for (NSEntityDescription *entity in [self entities])
	{
		MKCDAGNode *node = [entityNodes objectForKey:[entity name]];
		
		if(![root addNode:node])
		{
			NSLog(@"Couldn't add node of entity '%@' to root.", [entity name]);
			return nil;
		}
		
		for (NSRelationshipDescription *relationship in [[entity relationshipsByName] allValues])
		{
			BOOL shouldInclude = YES;
			
			if(dependencyFilter != nil)
			{
				shouldInclude = [dependencyFilter includeRelationship:relationship];
			}
			
			if(shouldInclude)
			{
				MKCDAGNode *childNode = [entityNodes objectForKey:[[relationship destinationEntity] name]];
				
				if(![node addNode:childNode])
				{
					NSLog(@"Couldn't add dependency '%@' -> '%@'. A cycle was detected.", [[relationship entity] name], [[relationship destinationEntity] name]);
					return nil;
				}
			}
		}
	}
	
	return root.objectsInTopologicalOrder;
}

- (NSArray *) entitiesInTopologicalOrder
{
	id defaultFilter = [[[MKCNSRelationshipDescriptionDefaultDependencyFilter alloc] init] autorelease];
	
	return [self entitiesInTopologicalOrderUsingDependencyFilter:defaultFilter];
}

@end
