//
//  ModelDepartmentEmployee.m
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelDepartmentEmployee.h instead.
//

#import "_ModelDepartmentEmployee.h"

#import "ModelDepartment.h"
#import "ModelEmployee.h"


@interface _ModelDepartmentEmployee()

@end

/** \ingroup DataModel */

@implementation _ModelDepartmentEmployee

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
		self.startedWorking = [dictionary objectForKey:@"ModelDepartmentEmployee.startedWorking"];
		
		
	}
	
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
	[dict setObjectIfNotNil:self.startedWorking forKey:@"ModelDepartmentEmployee.startedWorking"];
	
	
	
	
	
	
	[dict setObjectIfNotNil:[self.employee valueForKeyPath:@"name"] forKey:@"ModelDepartmentEmployee.employee"];
	
	
	
	return dict;
}

- (void)awakeFromDictionaryRepresentationInit
{
	if(self.sourceDictionaryRepresentation == nil)
		return; // awakeFromDictionaryRepresentationInit has been already executed on this object.
	
	self.employee = [(_ModelDepartmentEmployee<_ModelDepartmentEmployee> *)self fetchEmployeeObjectWithIDForEmployeeRelationship:[self.sourceDictionaryRepresentation objectForKey:@"ModelDepartmentEmployee.employee"]];
	[self.employee addDepartmentsObject:(ModelDepartmentEmployee*)self];
	
	


	[self.employee awakeFromDictionaryRepresentationInit];
	
	
	[super awakeFromDictionaryRepresentationInit];
}

#pragma mark Direct access



- (void)dealloc
{
	self.startedWorking = nil;
	
	self.department = nil;
	self.employee = nil;
	
	[super dealloc];
}

#pragma mark Synthesizes

@synthesize startedWorking;

@synthesize department;
@synthesize employee;

@end
