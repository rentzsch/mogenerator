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
 
 MKCDAGNode.m
 Created by Nikita Zhuk on 22.1.2011.
 */

#import "MKCDAGNode.h"

@interface MKCDAGNode()
/**
 All nodes directly reachable from this node ( = nodes to which there is a directed edge from 'self' node)
 */
@property(nonatomic, retain) NSMutableArray *nodes;
@end

@implementation MKCDAGNode

#pragma mark Algorithms

+ (BOOL)isCyclicNode:(MKCDAGNode *)node visitedNodes:(NSMutableSet *)visitedNodes
{
	if([visitedNodes intersectsSet:[NSSet setWithArray:node.nodes]])
	{
		// We've seen these nodes already - a cycle!
		return YES;
	}
	
	for (MKCDAGNode *childNode in node.nodes)
	{
		[visitedNodes addObject:childNode];
		BOOL childNodeIsCyclic = [self isCyclicNode:childNode visitedNodes:visitedNodes];
		[visitedNodes removeObject:childNode];
		
		if(childNodeIsCyclic)
		{
			return YES;
		}
	}
	
	return NO;
}

// DAG topological order visitor, see http://en.wikipedia.org/wiki/Directed_acyclic_graph
// 'visitedNodes' set is used to 'mark' visited nodes.
+ (void)visitNode:(MKCDAGNode *)node visitedNodes:(NSMutableSet *)visitedNodes orderedNodes:(NSMutableArray *)orderedNodes
{
	if([visitedNodes containsObject:node])
	{
		return;
	}
	
	[visitedNodes addObject:node];
	
	for (MKCDAGNode *childNode in node.nodes)
	{
		[self visitNode:childNode visitedNodes:visitedNodes orderedNodes:orderedNodes];
	}
	
	[orderedNodes addObject:node];
}

#pragma mark Public

- (id)initWithObject:(id)anObject
{
	if((self = [super init]))
	{
		self.nodes = [NSMutableArray array];
		self.object = anObject;
	}
	return self;
}

- (NSArray *)objectsInTopologicalOrder
{
	NSMutableArray *orderedNodes = [NSMutableArray array];
	
	[[self class] visitNode:self visitedNodes:[NSMutableSet set] orderedNodes:orderedNodes];
	
	NSMutableArray *orderedObjects = [NSMutableArray array];
	for (MKCDAGNode *node in orderedNodes)
	{
		if(node.object != nil)
		{
			[orderedObjects addObject:node.object];
		}
	}
	return orderedObjects;
}

- (BOOL)addNode:(MKCDAGNode *)node
{
	if(node == nil)
		return NO;
	
	if(![self.nodes containsObject:node])
		[self.nodes addObject:node];
	
	// Check that this node didn't cause a cycle - if it did, remove it.
	BOOL isCyclic = [[self class] isCyclicNode:node visitedNodes:[NSMutableSet set]];
	if(isCyclic)
	{
		[self.nodes removeObject:node];
	}
	
	return !isCyclic;
}

- (void) dealloc
{
	self.nodes = nil;
	self.object = nil;
	
	[super dealloc];
}

@synthesize nodes;
@synthesize object;
@end
