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

@class ModelDepartment;
@class ModelPerson;


@protocol _ModelCompany

@end


@interface _ModelCompany : ModelObject
{
	NSString *name;
	NSNumber *yearFounded;
	
	
	NSArray *departments;
	
	NSArray *people;
	
}

@property (nonatomic, retain, readwrite) NSString *name;
@property (nonatomic, retain, readwrite) NSNumber *yearFounded;
@property (nonatomic, assign, readwrite) int yearFoundedValue;

@property (nonatomic, retain, readonly) NSArray *departments;
@property (nonatomic, retain, readonly) NSArray *people;


- (void)addDepartmentsObject:(ModelDepartment*)value_;
- (void)removeDepartmentsObjects;
- (void)removeDepartmentsObject:(ModelDepartment*)value_;

- (void)addPeopleObject:(ModelPerson*)value_;
- (void)removePeopleObjects;
- (void)removePeopleObject:(ModelPerson*)value_;


@end
