//
//  ModelCompany.h
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelCompany.h instead.
//


#import <Foundation/Foundation.h>
#import "ModelObject.h"
#import "ModelObject.h"

@class ModelAssistant;
@class ModelDepartment;
@class ModelEmployee;


@protocol _ModelCompany

@end


@interface _ModelCompany : ModelObject <NSCoding>
{
	NSString *name;
	NSNumber *yearFounded;
	
	
	NSSet *assistants;
	
	NSSet *departments;
	
	NSSet *employees;
	
}

@property (nonatomic, retain, readwrite) NSString *name;
@property (nonatomic, retain, readwrite) NSNumber *yearFounded;
@property (nonatomic, assign, readwrite) int yearFoundedValue;

@property (nonatomic, retain, readonly) NSSet *assistants;
@property (nonatomic, retain, readonly) NSSet *departments;
@property (nonatomic, retain, readonly) NSSet *employees;


- (void)addAssistantsObject:(ModelAssistant*)value_ settingInverse: (BOOL) setInverse;
- (void)addAssistantsObject:(ModelAssistant*)value_;
- (void)removeAssistantsObjects;
- (void)removeAssistantsObject:(ModelAssistant*)value_ settingInverse: (BOOL) setInverse;
- (void)removeAssistantsObject:(ModelAssistant*)value_;

- (void)addDepartmentsObject:(ModelDepartment*)value_ settingInverse: (BOOL) setInverse;
- (void)addDepartmentsObject:(ModelDepartment*)value_;
- (void)removeDepartmentsObjects;
- (void)removeDepartmentsObject:(ModelDepartment*)value_ settingInverse: (BOOL) setInverse;
- (void)removeDepartmentsObject:(ModelDepartment*)value_;

- (void)addEmployeesObject:(ModelEmployee*)value_ settingInverse: (BOOL) setInverse;
- (void)addEmployeesObject:(ModelEmployee*)value_;
- (void)removeEmployeesObjects;
- (void)removeEmployeesObject:(ModelEmployee*)value_ settingInverse: (BOOL) setInverse;
- (void)removeEmployeesObject:(ModelEmployee*)value_;



@end
