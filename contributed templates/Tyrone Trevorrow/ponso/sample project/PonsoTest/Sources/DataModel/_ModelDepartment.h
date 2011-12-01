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
#import "ModelObject.h"

@class ModelDepartmentAssistant;
@class ModelCompany;
@class ModelDepartmentEmployee;


@protocol _ModelDepartment

@end


@interface _ModelDepartment : ModelObject <NSCoding>
{
	NSString *name;
	
	
	NSSet *assistants;
	
	ModelCompany *company;
	
	NSSet *employees;
	
}

@property (nonatomic, retain, readwrite) NSString *name;

@property (nonatomic, retain, readonly) NSSet *assistants;
@property (nonatomic, assign, readwrite) ModelCompany *company;

@property (nonatomic, retain, readonly) NSSet *employees;


- (void)addAssistantsObject:(ModelDepartmentAssistant*)value_ settingInverse: (BOOL) setInverse;
- (void)addAssistantsObject:(ModelDepartmentAssistant*)value_;
- (void)removeAssistantsObjects;
- (void)removeAssistantsObject:(ModelDepartmentAssistant*)value_ settingInverse: (BOOL) setInverse;
- (void)removeAssistantsObject:(ModelDepartmentAssistant*)value_;


- (void)addEmployeesObject:(ModelDepartmentEmployee*)value_ settingInverse: (BOOL) setInverse;
- (void)addEmployeesObject:(ModelDepartmentEmployee*)value_;
- (void)removeEmployeesObjects;
- (void)removeEmployeesObject:(ModelDepartmentEmployee*)value_ settingInverse: (BOOL) setInverse;
- (void)removeEmployeesObject:(ModelDepartmentEmployee*)value_;


- (void) setCompany: (ModelCompany*) company_ settingInverse: (BOOL) setInverse;


@end
