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

 MKCDAGNode.h
 Created by Nikita Zhuk on 22.1.2011.
 */

#import <Foundation/Foundation.h>

/**
 Generic DAG (Directed Acyclic Graph) implementation
 */
@interface MKCDAGNode : NSObject
{
	id object;
	NSMutableArray *nodes;
}

//! Generic payload object, not used in the algorithm. Can be nil.
@property(nonatomic, retain) id object;

//! All objects of nodes in topological order which are reachable from the receiver.
@property(nonatomic, readonly) NSArray *objectsInTopologicalOrder;

- (id)initWithObject:(id)object;

/**
 Creates dependency between receiver and the given node and adds the given node into the DAG.
 The dependency direction is from the receiver to the given node, e.g. [a addNode:b] means that 'a' depends on 'b'.
 If the new node would create a cycle in the DAG it's not added and NO is returned.
 YES is returned otherwise.
 */
- (BOOL)addNode:(MKCDAGNode *)node;

@end
