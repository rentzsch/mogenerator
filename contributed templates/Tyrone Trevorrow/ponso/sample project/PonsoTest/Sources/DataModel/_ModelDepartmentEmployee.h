//
//  ModelDepartmentEmployee.h
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelDepartmentEmployee.h instead.
//


#import <Foundation/Foundation.h>
#import "ModelObject.h"
#import "ModelObject.h"

@class ModelDepartment;
@class ModelEmployee;


@protocol _ModelDepartmentEmployee

- (ModelEmployee *)fetchEmployeeObjectWithIDForEmployeeRelationship:(id)objectID;

@end


@interface _ModelDepartmentEmployee : ModelObject <NSCoding>
{
	NSDate *startedWorking;
	
	
	ModelDepartment *department;
	
	ModelEmployee *employee;
	
}

@property (nonatomic, retain, readwrite) NSDate *startedWorking;

@property (nonatomic, assign, readwrite) ModelDepartment *department;

@property (nonatomic, retain, readwrite) ModelEmployee *employee;





- (void) setDepartment: (ModelDepartment*) department_ settingInverse: (BOOL) setInverse;

- (void) setEmployee: (ModelEmployee*) employee_ settingInverse: (BOOL) setInverse;


@end
