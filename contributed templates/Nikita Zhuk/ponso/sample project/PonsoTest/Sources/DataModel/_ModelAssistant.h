//
//  ModelAssistant.h
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelAssistant.h instead.
//


#import <Foundation/Foundation.h>
#import "ModelObject.h"

@class ModelEmployee;
@class ModelCompany;
@class ModelDepartmentAssistant;


@protocol _ModelAssistant

@end


@interface _ModelAssistant : ModelObject
{
	NSDate *birthDate;
	NSString *name;
	
	
	ModelEmployee *boss;
	
	ModelCompany *company;
	
	NSArray *departments;
	
}

@property (nonatomic, retain, readwrite) NSDate *birthDate;
@property (nonatomic, retain, readwrite) NSString *name;

@property (nonatomic, assign, readwrite) ModelEmployee *boss;

@property (nonatomic, assign, readwrite) ModelCompany *company;

@property (nonatomic, retain, readonly) NSArray *departments;




- (void)addDepartmentsObject:(ModelDepartmentAssistant*)value_;
- (void)removeDepartmentsObjects;
- (void)removeDepartmentsObject:(ModelDepartmentAssistant*)value_;


@end
