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
 
 MKCNSEntityDescriptionAdditions.h
 Created by Nikita Zhuk on 22.1.2011.
 */

#import <CoreData/CoreData.h>


@interface NSEntityDescription(MKCNSEntityDescriptionAdditions)

/** @TypeInfo NSAttributeDescription */
@property(nonatomic, readonly) NSArray *noninheritedRelationshipsInIDKeyPathTopologicalOrder;

// Checks if the managed object model of the receiver contains cycles in non-transient relationships.
// If cycles are found, an exception is raised.
- (void)checkNonTransientRelationshipCycles;

@end
