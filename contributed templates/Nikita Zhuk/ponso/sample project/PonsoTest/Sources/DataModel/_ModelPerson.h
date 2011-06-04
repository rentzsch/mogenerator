//
//  ModelPerson.h
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelPerson.h instead.
//


#import <Foundation/Foundation.h>
#import "ModelObject.h"

@class ModelCompany;
@class ModelDepartment;


@protocol _ModelPerson

@end


@interface _ModelPerson : ModelObject
{
	NSDate *birthDate;
	NSString *firstName;
	NSString *id;
	NSNumber *isOnVacation;
	NSString *lastName;
	
	
	ModelCompany *company;
	
	ModelDepartment *department;
	
}

@property (nonatomic, retain, readwrite) NSDate *birthDate;
@property (nonatomic, retain, readwrite) NSString *firstName;
@property (nonatomic, retain, readwrite) NSString *id;
@property (nonatomic, retain, readwrite) NSNumber *isOnVacation;
@property (nonatomic, assign, readwrite) BOOL isOnVacationValue;
@property (nonatomic, retain, readwrite) NSString *lastName;

@property (nonatomic, assign, readwrite) ModelCompany *company;

@property (nonatomic, assign, readwrite) ModelDepartment *department;






@end
