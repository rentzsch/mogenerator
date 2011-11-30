//
//  ModelDepartmentAssistant.h
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelDepartmentAssistant.h instead.
//


#import <Foundation/Foundation.h>
#import "ModelObject.h"

@class ModelAssistant;
@class ModelDepartment;


@protocol _ModelDepartmentAssistant

- (ModelAssistant *)fetchAssistantObjectWithIDForAssistantRelationship:(id)objectID;

@end


@interface _ModelDepartmentAssistant : ModelObject
{
	NSDate *startedWorking;
	
	
	ModelAssistant *assistant;
	
	ModelDepartment *department;
	
}

@property (nonatomic, retain, readwrite) NSDate *startedWorking;

@property (nonatomic, retain, readwrite) ModelAssistant *assistant;
@property (nonatomic, assign, readwrite) ModelDepartment *department;






@end
