//
//  ModelEmployee.h
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelEmployee.h instead.
//


#import <Foundation/Foundation.h>
#import "ModelObject.h"

@class ModelAssistant;
@class ModelCompany;
@class ModelDepartmentEmployee;


@protocol _ModelEmployee

- (ModelAssistant *)fetchAssistantObjectWithIDForAssistantRelationship:(id)objectID;

@end


@interface _ModelEmployee : ModelObject
{
	NSDate *birthDate;
	NSNumber *isOnVacation;
	NSString *name;
	
	
	ModelAssistant *assistant;
	
	ModelCompany *company;
	
	NSArray *departments;
	
}

@property (nonatomic, retain, readwrite) NSDate *birthDate;
@property (nonatomic, retain, readwrite) NSNumber *isOnVacation;
@property (nonatomic, assign, readwrite) BOOL isOnVacationValue;
@property (nonatomic, retain, readwrite) NSString *name;

@property (nonatomic, retain, readwrite) ModelAssistant *assistant;
@property (nonatomic, assign, readwrite) ModelCompany *company;

@property (nonatomic, retain, readonly) NSArray *departments;




- (void)addDepartmentsObject:(ModelDepartmentEmployee*)value_;
- (void)removeDepartmentsObjects;
- (void)removeDepartmentsObject:(ModelDepartmentEmployee*)value_;


@end
