//
//  ModelDepartment.m
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelDepartment.h instead.
//

#import "_ModelDepartment.h"

#import "ModelDepartmentAssistant.h"
#import "ModelCompany.h"
#import "ModelDepartmentEmployee.h"


@interface _ModelDepartment()
@property (nonatomic, retain, readwrite) NSArray *assistants;
@property (nonatomic, retain, readwrite) NSArray *employees;

@end

/** \ingroup DataModel */

@implementation _ModelDepartment

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
		self.name = [dictionary objectForKey:@"ModelDepartment.name"];
		
		
		for(id objectRepresentationForDict in [dictionary objectForKey:@"ModelDepartment.assistants"])
		{
			ModelDepartmentAssistant *assistantsObj = [[[ModelDepartmentAssistant alloc] initWithDictionaryRepresentation:objectRepresentationForDict] autorelease];
			[self addAssistantsObject:assistantsObj];
		}
		for(id objectRepresentationForDict in [dictionary objectForKey:@"ModelDepartment.employees"])
		{
			ModelDepartmentEmployee *employeesObj = [[[ModelDepartmentEmployee alloc] initWithDictionaryRepresentation:objectRepresentationForDict] autorelease];
			[self addEmployeesObject:employeesObj];
		}
	}
	
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
	[dict setObjectIfNotNil:self.name forKey:@"ModelDepartment.name"];
	
	if([self.assistants count] > 0)
	{
		
		NSMutableArray *assistantsRepresentationsForDictionary = [NSMutableArray arrayWithCapacity:[self.assistants count]];
		for(ModelDepartmentAssistant *obj in self.assistants)
		{
			[assistantsRepresentationsForDictionary addObject:[obj dictionaryRepresentation]];
		}
		[dict setObjectIfNotNil:assistantsRepresentationsForDictionary forKey:@"ModelDepartment.assistants"];
		
	}
	
	
	
	
	
	if([self.employees count] > 0)
	{
		
		NSMutableArray *employeesRepresentationsForDictionary = [NSMutableArray arrayWithCapacity:[self.employees count]];
		for(ModelDepartmentEmployee *obj in self.employees)
		{
			[employeesRepresentationsForDictionary addObject:[obj dictionaryRepresentation]];
		}
		[dict setObjectIfNotNil:employeesRepresentationsForDictionary forKey:@"ModelDepartment.employees"];
		
	}
	
	
	return dict;
}

- (void)awakeFromDictionaryRepresentationInit
{
	if(self.sourceDictionaryRepresentation == nil)
		return; // awakeFromDictionaryRepresentationInit has been already executed on this object.
	
	


	
	for(ModelDepartmentEmployee *employeesObj in self.employees)
	{
		[employeesObj awakeFromDictionaryRepresentationInit];
	}
	
	for(ModelDepartmentAssistant *assistantsObj in self.assistants)
	{
		[assistantsObj awakeFromDictionaryRepresentationInit];
	}
	
	
	[super awakeFromDictionaryRepresentationInit];
}

#pragma mark Direct access


- (void)addAssistantsObject:(ModelDepartmentAssistant*)value_
{
	if(self.assistants == nil)
	{
		self.assistants = [NSMutableArray array];
	}
		
	[(NSMutableArray *)self.assistants addObject:value_];
	value_.department = (ModelDepartment*)self;
}

- (void)removeAssistantsObjects
{
	self.assistants = [NSMutableArray array];
}

- (void)removeAssistantsObject:(ModelDepartmentAssistant*)value_
{
	value_.department = nil;
	[(NSMutableArray *)self.assistants removeObject:value_];
}


- (void)addEmployeesObject:(ModelDepartmentEmployee*)value_
{
	if(self.employees == nil)
	{
		self.employees = [NSMutableArray array];
	}
		
	[(NSMutableArray *)self.employees addObject:value_];
	value_.department = (ModelDepartment*)self;
}

- (void)removeEmployeesObjects
{
	self.employees = [NSMutableArray array];
}

- (void)removeEmployeesObject:(ModelDepartmentEmployee*)value_
{
	value_.department = nil;
	[(NSMutableArray *)self.employees removeObject:value_];
}



- (void)dealloc
{
	self.name = nil;
	
	self.assistants = nil;
	self.company = nil;
	self.employees = nil;
	
	[super dealloc];
}

#pragma mark Synthesizes

@synthesize name;

@synthesize assistants;
@synthesize company;
@synthesize employees;

@end
