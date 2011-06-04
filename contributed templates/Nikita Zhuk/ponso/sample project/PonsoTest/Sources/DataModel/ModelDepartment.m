//
//  ModelDepartment.m
//	
//  $Id$
//

#import "ModelDepartment.h"

@implementation ModelDepartment

#pragma mark Abstract method overrides


- (ModelPerson *)fetchPersonObjectWithIDForPeopleRelationship:(id)objectID
{
    return [[self.people filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id = %@", objectID]] lastObject]; 
}



// Custom logic goes here.

@end
