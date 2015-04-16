//
//  ModelDepartmentAssistant.m
//	
//  $Id$
//

#import "ModelDepartmentAssistant.h"

@implementation ModelDepartmentAssistant

#pragma mark Abstract method overrides


- (ModelAssistant *)fetchAssistantObjectWithIDForAssistantRelationship:(id)objectID
{
    NSAssert(self.department.company != nil, @"");
    
    return [[self.department.company.assistants filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", objectID]] lastObject];
}

@end
