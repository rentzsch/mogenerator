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

@class ModelCompany;
@class ModelPerson;


@protocol _ModelDepartment

- (ModelPerson *)fetchPersonObjectWithIDForPeopleRelationship:(id)objectID;

@end


@interface _ModelDepartment : ModelObject
{
	NSString *name;
	
	
	ModelCompany *company;
	
	NSArray *people;
	
}

@property (nonatomic, retain, readwrite) NSString *name;

@property (nonatomic, assign, readwrite) ModelCompany *company;

@property (nonatomic, retain, readonly) NSArray *people;



- (void)addPeopleObject:(ModelPerson*)value_;
- (void)removePeopleObjects;
- (void)removePeopleObject:(ModelPerson*)value_;


@end
