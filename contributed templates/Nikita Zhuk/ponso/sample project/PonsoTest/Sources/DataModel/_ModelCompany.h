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

@class ModelAssistant;
@class ModelDepartment;
@class ModelEmployee;


@protocol _ModelCompany

@end


@interface _ModelCompany : ModelObject
{
	NSString *name;
	NSNumber *yearFounded;
	
	
	NSArray *assistants;
	
	NSArray *departments;
	
	NSArray *employees;
	
}

@property (nonatomic, retain, readwrite) NSString *name;
@property (nonatomic, retain, readwrite) NSNumber *yearFounded;
@property (nonatomic, assign, readwrite) int yearFoundedValue;

@property (nonatomic, retain, readonly) NSArray *assistants;
@property (nonatomic, retain, readonly) NSArray *departments;
@property (nonatomic, retain, readonly) NSArray *employees;


- (void)addAssistantsObject:(ModelAssistant*)value_;
- (void)removeAssistantsObjects;
- (void)removeAssistantsObject:(ModelAssistant*)value_;

- (void)addDepartmentsObject:(ModelDepartment*)value_;
- (void)removeDepartmentsObjects;
- (void)removeDepartmentsObject:(ModelDepartment*)value_;

- (void)addEmployeesObject:(ModelEmployee*)value_;
- (void)removeEmployeesObjects;
- (void)removeEmployeesObject:(ModelEmployee*)value_;


@end
