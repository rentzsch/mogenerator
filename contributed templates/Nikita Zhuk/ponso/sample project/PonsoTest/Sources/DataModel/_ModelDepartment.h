//
//  ModelDepartment.h
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelDepartment.h instead.
//


#import <Foundation/Foundation.h>
#import "ModelObject.h"

@class ModelDepartmentAssistant;
@class ModelCompany;
@class ModelDepartmentEmployee;


@protocol _ModelDepartment

@end


@interface _ModelDepartment : ModelObject
{
	NSString *name;
	
	
	NSArray *assistants;
	
	ModelCompany *company;
	
	NSArray *employees;
	
}

@property (nonatomic, retain, readwrite) NSString *name;

@property (nonatomic, retain, readonly) NSArray *assistants;
@property (nonatomic, assign, readwrite) ModelCompany *company;

@property (nonatomic, retain, readonly) NSArray *employees;


- (void)addAssistantsObject:(ModelDepartmentAssistant*)value_;
- (void)removeAssistantsObjects;
- (void)removeAssistantsObject:(ModelDepartmentAssistant*)value_;


- (void)addEmployeesObject:(ModelDepartmentEmployee*)value_;
- (void)removeEmployeesObjects;
- (void)removeEmployeesObject:(ModelDepartmentEmployee*)value_;


@end
