//
//  ModelDepartmentAssistant.m
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelDepartmentAssistant.h instead.
//

#import "_ModelDepartmentAssistant.h"

#import "ModelAssistant.h"
#import "ModelDepartment.h"


@interface _ModelDepartmentAssistant()

@end

/** \ingroup DataModel */

@implementation _ModelDepartmentAssistant

- (id)init
{
	if((self = [super init]))
	{
		
	}
	
	return self;
}

#pragma mark Scalar values



#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
		self.startedWorking = [dictionary objectForKey:@"ModelDepartmentAssistant.startedWorking"];
		
		
	}
	
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
	[dict setObjectIfNotNil:self.startedWorking forKey:@"ModelDepartmentAssistant.startedWorking"];
	
	
	[dict setObjectIfNotNil:[self.assistant valueForKeyPath:@"name"] forKey:@"ModelDepartmentAssistant.assistant"];
	
	
	
	
	
	
	
	return dict;
}

- (void)awakeFromDictionaryRepresentationInit
{
	if(self.sourceDictionaryRepresentation == nil)
		return; // awakeFromDictionaryRepresentationInit has been already executed on this object.
	
	self.assistant = [(_ModelDepartmentAssistant<_ModelDepartmentAssistant> *)self fetchAssistantObjectWithIDForAssistantRelationship:[self.sourceDictionaryRepresentation objectForKey:@"ModelDepartmentAssistant.assistant"]];
	[self.assistant addDepartmentsObject:(ModelDepartmentAssistant*)self];
	
	


	[self.assistant awakeFromDictionaryRepresentationInit];
	
	
	[super awakeFromDictionaryRepresentationInit];
}

#pragma mark Direct access



- (void)dealloc
{
	self.startedWorking = nil;
	
	self.assistant = nil;
	self.department = nil;
	
	[super dealloc];
}

#pragma mark Synthesizes

@synthesize startedWorking;

@synthesize assistant;
@synthesize department;

@end
