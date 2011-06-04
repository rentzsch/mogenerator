//
//  ModelCompany.m
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelCompany.h instead.
//

#import "_ModelCompany.h"

#import "ModelAssistant.h"
#import "ModelDepartment.h"
#import "ModelEmployee.h"


@interface _ModelCompany()
@property (nonatomic, retain, readwrite) NSArray *assistants;
@property (nonatomic, retain, readwrite) NSArray *departments;
@property (nonatomic, retain, readwrite) NSArray *employees;

@end

/** \ingroup DataModel */

@implementation _ModelCompany

- (id)init
{
	if((self = [super init]))
	{
		
	}
	
	return self;
}

#pragma mark Scalar values

- (int)yearFoundedValue
{
	return [self.yearFounded intValue];
}

- (void)setYearFoundedValue:(int)value_
{
	self.yearFounded = [NSNumber numberWithInt:value_];
}



#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
		self.name = [dictionary objectForKey:@"ModelCompany.name"];
		self.yearFounded = [dictionary objectForKey:@"ModelCompany.yearFounded"];
		
		
		for(id objectRepresentationForDict in [dictionary objectForKey:@"ModelCompany.assistants"])
		{
			ModelAssistant *assistantsObj = [[[ModelAssistant alloc] initWithDictionaryRepresentation:objectRepresentationForDict] autorelease];
			[self addAssistantsObject:assistantsObj];
		}
		for(id objectRepresentationForDict in [dictionary objectForKey:@"ModelCompany.departments"])
		{
			ModelDepartment *departmentsObj = [[[ModelDepartment alloc] initWithDictionaryRepresentation:objectRepresentationForDict] autorelease];
			[self addDepartmentsObject:departmentsObj];
		}
		for(id objectRepresentationForDict in [dictionary objectForKey:@"ModelCompany.employees"])
		{
			ModelEmployee *employeesObj = [[[ModelEmployee alloc] initWithDictionaryRepresentation:objectRepresentationForDict] autorelease];
			[self addEmployeesObject:employeesObj];
		}
	}
	
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
	[dict setObjectIfNotNil:self.name forKey:@"ModelCompany.name"];
	[dict setObjectIfNotNil:self.yearFounded forKey:@"ModelCompany.yearFounded"];
	
	if([self.assistants count] > 0)
	{
		
		NSMutableArray *assistantsRepresentationsForDictionary = [NSMutableArray arrayWithCapacity:[self.assistants count]];
		for(ModelAssistant *obj in self.assistants)
		{
			[assistantsRepresentationsForDictionary addObject:[obj dictionaryRepresentation]];
		}
		[dict setObjectIfNotNil:assistantsRepresentationsForDictionary forKey:@"ModelCompany.assistants"];
		
	}
	
	if([self.departments count] > 0)
	{
		
		NSMutableArray *departmentsRepresentationsForDictionary = [NSMutableArray arrayWithCapacity:[self.departments count]];
		for(ModelDepartment *obj in self.departments)
		{
			[departmentsRepresentationsForDictionary addObject:[obj dictionaryRepresentation]];
		}
		[dict setObjectIfNotNil:departmentsRepresentationsForDictionary forKey:@"ModelCompany.departments"];
		
	}
	
	if([self.employees count] > 0)
	{
		
		NSMutableArray *employeesRepresentationsForDictionary = [NSMutableArray arrayWithCapacity:[self.employees count]];
		for(ModelEmployee *obj in self.employees)
		{
			[employeesRepresentationsForDictionary addObject:[obj dictionaryRepresentation]];
		}
		[dict setObjectIfNotNil:employeesRepresentationsForDictionary forKey:@"ModelCompany.employees"];
		
	}
	
	
	return dict;
}

- (void)awakeFromDictionaryRepresentationInit
{
	if(self.sourceDictionaryRepresentation == nil)
		return; // awakeFromDictionaryRepresentationInit has been already executed on this object.
	
	


	
	for(ModelDepartment *departmentsObj in self.departments)
	{
		[departmentsObj awakeFromDictionaryRepresentationInit];
	}
	
	for(ModelAssistant *assistantsObj in self.assistants)
	{
		[assistantsObj awakeFromDictionaryRepresentationInit];
	}
	
	for(ModelEmployee *employeesObj in self.employees)
	{
		[employeesObj awakeFromDictionaryRepresentationInit];
	}
	
	
	[super awakeFromDictionaryRepresentationInit];
}

#pragma mark Direct access


- (void)addAssistantsObject:(ModelAssistant*)value_
{
	if(self.assistants == nil)
	{
		self.assistants = [NSMutableArray array];
	}
		
	[(NSMutableArray *)self.assistants addObject:value_];
	value_.company = (ModelCompany*)self;
}

- (void)removeAssistantsObjects
{
	self.assistants = [NSMutableArray array];
}

- (void)removeAssistantsObject:(ModelAssistant*)value_
{
	value_.company = nil;
	[(NSMutableArray *)self.assistants removeObject:value_];
}


- (void)addDepartmentsObject:(ModelDepartment*)value_
{
	if(self.departments == nil)
	{
		self.departments = [NSMutableArray array];
	}
		
	[(NSMutableArray *)self.departments addObject:value_];
	value_.company = (ModelCompany*)self;
}

- (void)removeDepartmentsObjects
{
	self.departments = [NSMutableArray array];
}

- (void)removeDepartmentsObject:(ModelDepartment*)value_
{
	value_.company = nil;
	[(NSMutableArray *)self.departments removeObject:value_];
}


- (void)addEmployeesObject:(ModelEmployee*)value_
{
	if(self.employees == nil)
	{
		self.employees = [NSMutableArray array];
	}
		
	[(NSMutableArray *)self.employees addObject:value_];
	value_.company = (ModelCompany*)self;
}

- (void)removeEmployeesObjects
{
	self.employees = [NSMutableArray array];
}

- (void)removeEmployeesObject:(ModelEmployee*)value_
{
	value_.company = nil;
	[(NSMutableArray *)self.employees removeObject:value_];
}



- (void)dealloc
{
	self.name = nil;
	self.yearFounded = nil;
	
	self.assistants = nil;
	self.departments = nil;
	self.employees = nil;
	
	[super dealloc];
}

#pragma mark Synthesizes

@synthesize name;
@synthesize yearFounded;

@synthesize assistants;
@synthesize departments;
@synthesize employees;

@end
