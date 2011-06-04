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

@class ModelPerson;
@class ModelDepartment;


@protocol _ModelCompany

@end


@interface _ModelCompany : ModelObject
{
	NSString *name;
	NSNumber *yearFounded;
	
	
	NSArray *people;
	
	NSArray *departments;
	
}

@property (nonatomic, retain, readwrite) NSString *name;
@property (nonatomic, retain, readwrite) NSNumber *yearFounded;
@property (nonatomic, assign, readwrite) int yearFoundedValue;

@property (nonatomic, retain, readonly) NSArray *people;
@property (nonatomic, retain, readonly) NSArray *departments;


- (void)addPeopleObject:(ModelPerson*)value_;
- (void)removePeopleObjects;
- (void)removePeopleObject:(ModelPerson*)value_;

- (void)addDepartmentsObject:(ModelDepartment*)value_;
- (void)removeDepartmentsObjects;
- (void)removeDepartmentsObject:(ModelDepartment*)value_;


@end
