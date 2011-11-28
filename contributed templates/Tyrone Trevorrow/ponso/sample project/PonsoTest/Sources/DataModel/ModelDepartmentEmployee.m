//
//  ModelDepartmentEmployee.m
//	
//  $Id$
//

#import "ModelDepartmentEmployee.h"

@implementation ModelDepartmentEmployee

#pragma mark Abstract method overrides


- (ModelEmployee *)fetchEmployeeObjectWithIDForEmployeeRelationship:(id)objectID
{
    NSAssert(self.department.company != nil, @"");
    
    return [[self.department.company.employees filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", objectID]] lastObject];
}

@end
