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
#import "ModelObject.h"

@class ModelAssistant;
@class ModelCompany;
@class ModelDepartmentEmployee;


@protocol _ModelEmployee

- (ModelAssistant *)fetchAssistantObjectWithIDForAssistantRelationship:(id)objectID;

@end


@interface _ModelEmployee : ModelObject <NSCoding>
{
	NSDate *birthDate;
	NSNumber *isOnVacation;
	NSString *name;
	
	
	ModelAssistant *assistant;
	
	ModelCompany *company;
	
	NSSet *departments;
	
}

@property (nonatomic, retain, readwrite) NSDate *birthDate;
@property (nonatomic, retain, readwrite) NSNumber *isOnVacation;
@property (nonatomic, assign, readwrite) BOOL isOnVacationValue;
@property (nonatomic, retain, readwrite) NSString *name;

@property (nonatomic, retain, readwrite) ModelAssistant *assistant;
@property (nonatomic, assign, readwrite) ModelCompany *company;

@property (nonatomic, retain, readonly) NSSet *departments;




- (void)addDepartmentsObject:(ModelDepartmentEmployee*)value_ settingInverse: (BOOL) setInverse;
- (void)addDepartmentsObject:(ModelDepartmentEmployee*)value_;
- (void)removeDepartmentsObjects;
- (void)removeDepartmentsObject:(ModelDepartmentEmployee*)value_ settingInverse: (BOOL) setInverse;
- (void)removeDepartmentsObject:(ModelDepartmentEmployee*)value_;


- (void) setAssistant: (ModelAssistant*) assistant_ settingInverse: (BOOL) setInverse;

- (void) setCompany: (ModelCompany*) company_ settingInverse: (BOOL) setInverse;


@end
