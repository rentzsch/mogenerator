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
 
 MKCNSManagedObjectModelAdditions.h
 Created by Nikita Zhuk on 22.1.2011.
 */

#import <CoreData/CoreData.h>


@protocol MKCNSRelationshipDescriptionDependencyFilter<NSObject>
- (BOOL)includeRelationship:(NSRelationshipDescription *)relationship;
@end

@interface NSManagedObjectModel(MKCNSManagedObjectModelAdditions)

/**
 Array of NSEntityDescription objects, sorted in topological order
 based on relationships between entity descriptions.
 If there are cyclic dependencies, a nil is returned.
 This method counts all relationships as dependencies if they are not marked as being 'transient'.
 */

- (NSArray *) entitiesInTopologicalOrder;

/*
 Same as entitiesInTopologicalOrder, but uses the given dependencyFilter to decide whether a
 relationship should be counted as dependency or not.
 */
- (NSArray *) entitiesInTopologicalOrderUsingDependencyFilter:(id<MKCNSRelationshipDescriptionDependencyFilter>) dependencyFilter;

@end
