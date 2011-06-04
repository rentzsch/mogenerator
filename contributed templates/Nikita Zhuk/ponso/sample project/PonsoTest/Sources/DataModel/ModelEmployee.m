//
//  ModelEmployee.m
//	
//  $Id$
//

#import "ModelEmployee.h"
#import "ModelCompany.h"

@implementation ModelEmployee

#pragma mark Abstract method overrides

- (ModelAssistant *)fetchAssistantObjectWithIDForAssistantRelationship:(id)objectID
{
    NSAssert(self.company != nil, @"");
    
    return [[self.company.assistants filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", objectID]] lastObject];
}

@end
